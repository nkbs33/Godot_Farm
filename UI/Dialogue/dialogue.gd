extends Control
signal finish 

var global_data
var dialog_index = -1:
	set(value):
		dialog_index=value
		update_dialog()
var dialog_data
var hud

@export var smooth_display_enabled:bool = true
@export var text_speed = 5
var is_smooth_playing:bool = false
var smooth_play_timer:float

@onready var d_name = $Box.get_node("Name")
@onready var d_text = $Box.get_node("Text")

func _ready():
	#var f = FileAccess.open("res://UI/Dialogue/assets/dialog_file.json", FileAccess.READ)
	#dialog_data = JSON.parse_string(f.get_as_text())
	var global_data = get_node("/root/GlobalData")
	global_data.dialog_ui = self
	hud = get_parent()

func toggle_visible(vis):
	visible = vis
	if vis:
		hud.focus = self
	else:
		hud.focus = null
		finish.emit()
		var cs = finish.get_connections()
		for c in cs:
			finish.disconnect(c.callable)

func start_dialog():
	toggle_visible(true)
	dialog_index = 0
	smooth_display()

func _input(event):
	if not visible or is_smooth_playing:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("cancel"):
		dialog_index += 1
		
func update_dialog():
	if dialog_index >= dialog_data.size():
		toggle_visible(false)
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

func move_by_vec(vec):
	return false 
