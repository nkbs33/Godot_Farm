class_name HUD
extends CanvasLayer

@onready var backpack = $Backpack
@onready var dialog = $Dialogue
var occupied_by = []
var move_vec:Vector2

func _ready():
	GlobalData.hud = self
	Event.move_in_ui.connect(reset_ui_timer)

func clear():
	if occupied_by:
		occupied_by.toggle_visible(false)

func reset_ui_timer():
	$MoveTimer.start()

func _input(event):
	if occupied_by or not $MoveTimer.is_stopped():
		return
	if event.is_action_pressed("backpack"):
		$Backpack.toggle_visible(true)
		get_viewport().set_input_as_handled()

func _process(_delta):
	move_vec = Vector2(0,0) 
	if not occupied_by or not $MoveTimer.is_stopped():
		return
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if move_vec == Vector2.ZERO:
		return
