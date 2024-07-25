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

var interactable_list = []
var paused:bool
var equipment 
var mouse_pos:Vector2

func _ready():
	Event.player_pause.connect(pause)
	Event.player_resume.connect(resume)
	Event.player_equip.connect(func(eq): equipment = eq)
	Event.player_unequip.connect(func(): equipment = null)

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

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = get_global_transform_with_canvas().affine_inverse() * event.position
		Event.player_move.emit(effective_pos())

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
	var max_reach = 15.9
	if abs(mouse_pos.x) > max_reach * 1.5:
		mouse_pos.x = 9999
	elif abs(mouse_pos.x) > max_reach:
		mouse_pos.x = sign(mouse_pos.x) * max_reach
		
	if abs(mouse_pos.y) > max_reach * 1.5:
		mouse_pos.y = 9999
	elif abs(mouse_pos.y) > max_reach:
		mouse_pos.y = sign(mouse_pos.y) * max_reach
	return global_position + mouse_pos

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

func use_equipment():
	if equipment != null:
		equipment.on_use()
