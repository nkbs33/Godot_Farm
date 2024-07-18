extends Control

@onready var hud:HUD = get_parent()
@onready var d_name = $Box.get_node("Name")
@onready var d_text = $Box.get_node("Text")

var dialog_data
var dialog_index = -1:
	set(value):
		dialog_index=value
		update_dialog()
		
@export var smooth_display_enabled:bool = true
@export var text_speed = 5
var is_smooth_playing:bool = false
var smooth_play_timer:float


func _ready():
	Event.start_dialog.connect(start_dialog)

func toggle_visible(vis):
	visible = vis
	if vis:
		hud.clear()
		hud.occupied_by = self
	else:
		hud.occupied_by = null
	
func start_dialog(dialog_data_):
	toggle_visible(true)
	dialog_data = dialog_data_
	dialog_index = 0
	smooth_display()
	Event.player_pause.emit()

func end_dialog():
	toggle_visible(false)
	Event.end_dialog.emit()
	Event.player_resume.emit()

func _input(event):
	if not visible or is_smooth_playing:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("cancel"):
		dialog_index += 1
	get_viewport().set_input_as_handled()
		
func update_dialog():
	if dialog_index >= dialog_data.size():
		end_dialog()
		return
	d_name.text = "[center]"+dialog_data[dialog_index]["name"]+"[/center]"
	d_text.text = dialog_data[dialog_index]["text"]
	smooth_display()
	
func smooth_display():
	if not smooth_display_enabled:
		return
	d_text.visible_characters = 0
	is_smooth_playing = true
	smooth_play_timer = 0
	
func _process(delta):
	if not is_smooth_playing:
		return
	smooth_play_timer += delta 
	while smooth_play_timer > 0.05/text_speed:
		increase_display_length()
		smooth_play_timer -= 0.05/text_speed

func increase_display_length():
	d_text.visible_characters += 1
	if d_text.visible_characters >= dialog_data[dialog_index]["text"].length():
		is_smooth_playing = false

func move_by_vec(_vec):
	return false 
