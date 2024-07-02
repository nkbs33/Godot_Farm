extends Control
signal exit 

var dialog_index = -1
var dialog_data

@export var smooth_display_enabled:bool = true
@export var text_speed = 5
var is_smooth_playing:bool = false
var smooth_play_timer:float

@onready var d_name = $Box.get_node("Name")
@onready var d_text = $Box.get_node("Text")

func _ready():
	var f = FileAccess.open("res://UI/Dialogue/assets/dialog_file.json", FileAccess.READ)
	dialog_data = JSON.parse_string(f.get_as_text())

func toggle_visible(vis):
	visible = vis
	dialog_index = -1

func handle_action(action):
	if action == "ui_accept" and not is_smooth_playing:
		dialog_index += 1
		update_dialog()
		
func update_dialog():
	if dialog_index >= dialog_data.size():
		exit.emit()
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
	if d_text.visible_characters == dialog_data[dialog_index]["text"].length():
		is_smooth_playing = false
