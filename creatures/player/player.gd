class_name Player
extends CharacterBody2D

@export var max_speed = 75.0
@export var speed_lerp = 0.5
var speed
var direction = Vector2(0, 1)

# movement
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var state_machine = $AnimationTree["parameters/playback"]

# intearact
var interactable_list = []
var equipment
var paused:bool

func _ready():
	Event.player_pause.connect(pause)
	Event.player_resume.connect(resume)
	Event.equip_backpack_item.connect(equip_from_backpack)

func get_input_vec():
	var inputVec = Vector2.ZERO
	if not paused:
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
		move_and_slide()
		Event.player_move.emit(effective_pos())
	else:
		speed = 0
		velocity = Vector2.ZERO
	
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

func pause():
	paused = true
func resume():
	paused = false

func interact():
	if interactable_list.size() > 0:
		var i = interactable_list[0]
		i.on_interact()
	else:
		GlobalData.on_player_interact()

func add_interactable(item):
	interactable_list.append(item)

func remove_interactable(item):
	interactable_list.erase(item)

func equip_from_backpack(idx):
	set_equipment(GlobalData.backpack.items[idx].name)

func set_equipment(equipment_name):
	var d = GlobalData.db_agent.query_item_data(equipment_name)
	if not d.has("eq_path"):
		return
	var eqnode = load("res://"+d.eq_path).instantiate()
	if d.type == "seed":
		eqnode.item_name = d.name
		eqnode.crop_name = d.crop	
	equipment = eqnode
	Event.player_equip.emit(equipment)
	
func use_equipment():
	if not equipment:
		return
	equipment.on_use()
