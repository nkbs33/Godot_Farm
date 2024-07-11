extends CharacterBody2D

@export var max_speed = 75.0
@export var speed_lerp = 0.5
var speed
var direction = Vector2(0, 1)

var global_data
var effective_position = Vector2()
var input_enabled:bool = true 

# movement
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var state_machine = $AnimationTree["parameters/playback"]

# intearact
var interactable_list = []
var equipment

func _ready():
	global_data = get_node("/root/GlobalData")
	global_data.player = self
	
func get_input_vec():
	var inputVec = Vector2.ZERO
	if not input_enabled:
		return inputVec
	if Input.is_action_pressed("move_right"):
		inputVec.x += 1
	if Input.is_action_pressed("move_left"):
		inputVec.x -= 1
	if Input.is_action_pressed("move_up"):
		inputVec.y -= 1
	if Input.is_action_pressed("move_down"):
		inputVec.y += 1
	return inputVec 

func _physics_process(_delta):
	var input_vec = get_input_vec()
	if input_vec.length()>0:
		direction = input_vec
		speed = (1-speed_lerp)*speed + speed_lerp*max_speed
		velocity = input_vec.normalized() * speed
	else:
		speed = 0
		velocity = Vector2.ZERO
	move_and_slide()
	
	if input_vec.length()>0:
		if input_vec.x < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		state_machine.travel("walk")
		animation_tree.set("parameters/walk/blend_position", input_vec)
	else:
		state_machine.travel("idle")
		animation_tree.set("parameters/idle/blend_position", direction)

func effective_pos():
	return global_position + direction * 4

func enable_control(enabled):
	input_enabled = enabled

func interact():
	if interactable_list.size() == 0:
		global_data.on_player_interact()
		return
	var i = interactable_list[0]
	i.on_interact()

func add_interactable(item):
	interactable_list.append(item)

func remove_interactable(item):
	interactable_list.erase(item)

func set_equipment(eq):
	var d = global_data.db_agent.query_item_data(eq)
	if not d.has("eq_path"):
		return
	var eqnode = load("res://"+d.eq_path).instantiate()
	if d.type == "seed":
		eqnode.item_name = d.name
		eqnode.crop_name = d.crop	
	var equi = global_data.hud.get_node("Gadgets/EquipmentUI")
	var ex = equi.get_child(0)
	if ex:
		ex.queue_free()
	equi.add_child(eqnode)
	eqnode.position = Vector2i(16,16)
	equipment = eqnode

func use_equipment():
	if not equipment:
		return
	equipment.on_use()
