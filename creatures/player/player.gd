extends CharacterBody2D
@export var max_speed = 75.0
@export var speed_lerp = 0.5
var speed
var direction = Vector2(0, 1)

signal use_item(item)
signal toggle_panel(panel)

var global_data
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var effective_position = Vector2()
var input_enabled:bool = true 
# movement
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var state_machine = $AnimationTree["parameters/playback"]
# intearact
var interactable_list = []

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

func _physics_process(delta):
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

func _input(event):
	if not input_enabled:
		return
	if event.is_action_pressed("backpack"):
		toggle_panel.emit("backpack")
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("interact"):
		interact()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("cancel"):
		global_data.set_crop()

func effective_pos():
	return global_position + direction * 4
	
#func collect(item):
	#if item.name == "Carrot":
	#	backpack_data.add_item("carrot")
	#	item.queue_free()

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
