extends CharacterBody2D
@export var speed = 300.0
var direction = Vector2(0, 1)

signal use_item(item)
signal toggle_panel(panel)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var effective_position = Vector2()
var input_enabled:bool = true 
@onready var backpack_data = get_node("/root/GlobalDataManager/BackpackData")
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var state_machine = $AnimationTree["parameters/playback"]

var input_vec_nz = Vector2(0,1)
var interactable_list = []

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
		velocity = input_vec.normalized() * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
	if input_vec.length()>0:
		if input_vec.x < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		
		state_machine.travel("walk")
		animation_tree.set("parameters/walk/blend_position", input_vec)
		input_vec_nz = input_vec 
		pass
	else:
		state_machine.travel("idle")
		animation_tree.set("parameters/idle/blend_position", input_vec_nz)

func _input(event):
	if event.is_action_pressed("backpack"):
		toggle_panel.emit("backpack")
	elif event.is_action_pressed("interact"):
		interact()

func _process(delta):
	effective_position = global_position + direction * 10
	
func collect(item):
	if backpack_data.num_empty == 0:
			return
	if item.name == "Carrot":
		backpack_data.add_item("carrot")
		item.queue_free()

func toggle_controllable(controllable):
	input_enabled = controllable

func interact():
	if interactable_list.size() == 0:
		return
	var i = interactable_list[0]
	i.on_interact()
	
func add_interactable(item):
	interactable_list.append(item)

func remove_interactable(item):
	interactable_list.erase(item)
