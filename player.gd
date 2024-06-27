extends CharacterBody2D
@export var speed = 300.0
var direction = Vector2(0, 1)

signal interact()
signal use_item(item)
signal toggle_backpack()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var effective_position = Vector2()
@onready var backpack_data = get_node("/root/GlobalDataManager/BackpackData")
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var state_machine = $AnimationTree["parameters/playback"]
#parameters/walk/blend_position

func _physics_process(delta):
	var inputVec = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		inputVec.x += 1
	if Input.is_action_pressed("move_left"):
		inputVec.x -= 1
	if Input.is_action_pressed("move_up"):
		inputVec.y -= 1
	if Input.is_action_pressed("move_down"):
		inputVec.y += 1
	if inputVec.length()>0:
		direction = inputVec
		velocity = inputVec.normalized() * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
	if inputVec.length()>0:
		if inputVec.x < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		state_machine.travel("walk")
		animation_tree.set("parameters/walk/blend_position", inputVec)
		pass
	else:
		state_machine.travel("idle")

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_J:
				interact.emit()
			if event.keycode == KEY_I:
				use_item.emit("carrot_seed")
			if event.keycode == KEY_K:
				use_item.emit("water")
			if event.keycode == KEY_E:
				toggle_backpack.emit()

func _process(delta):
	effective_position = global_position + direction * 10
	
func collect(item):
	if backpack_data.num_empty == 0:
			return
	if item.name == "Carrot":
		backpack_data.add_item("carrot")
		item.queue_free()
