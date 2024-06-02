extends CharacterBody2D
@export var speed = 300.0
var direction = Vector2(0, 1)

signal query_coords(world_pos)
signal interact()
signal use_item(item)
signal toggle_backpack()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var backpack_data

func _ready():
	backpack_data = get_node("/root/GlobalDataManager/BackpackData")

func _physics_process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if velocity.length()>0:
		direction = velocity
		velocity = velocity.normalized() * speed
	# print(velocity)
	
	move_and_slide()
	
	if velocity.length()>0:
		if velocity.y == 0:
			$AnimatedSprite2D.animation = "walk"
			if velocity.x < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		elif velocity.y > 0:
			$AnimatedSprite2D.animation = "walk_down"
		else:
			$AnimatedSprite2D.animation = "walk_up"
		$AnimatedSprite2D.play()
		
	else:
		$AnimatedSprite2D.animation = "idle"

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
	query_coords.emit(global_position + direction * 10)
	
func collect(item):
	if backpack_data.num_empty == 0:
			return
	if item.name == "Carrot":
		backpack_data.add_item("carrot")
		item.queue_free()
