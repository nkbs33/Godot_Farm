extends Control

@onready var hud:HUD = get_parent()
@onready var d_name = $DialogBox.get_node("Name")
@onready var d_text = $DialogBox.get_node("Text")

var dialog_data
var dialog_index = -1:
	set(value):
		dialog_index=value
		update_dialog()
		
@export var smooth_display_enabled:bool = true
@export var text_speed = 5
var is_smooth_playing:bool = false
var smooth_play_timer:float
var has_option:bool = false


func _ready():
	Event.start_dialog.connect(_on_start_dialog)
	Event.end_dialog.connect(_on_end_dialog)
	Event.show_next_line.connect(_on_show_next_line)
	setup_options()

func toggle_visible(vis):
	visible = vis
	
func _on_start_dialog(dialog_data_, dialog_index_):
	toggle_visible(true)
	dialog_data = dialog_data_
	dialog_index = dialog_index_
	smooth_display()
	Event.player_pause.emit()

func _on_end_dialog():
	toggle_visible(false)
	Event.player_resume.emit()

func _on_show_next_line(idx):
	dialog_index = idx

func _input(event):
	if not visible or is_smooth_playing:
		return
	if not has_option and (event.is_action_pressed("interact") or event.is_action_pressed("cancel")):
		Event.get_next_line.emit()
		get_viewport().set_input_as_handled()
		
func update_dialog():
	hide_options()
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
		show_options()

func setup_options():
	for i in range(1,3):
		var c = $OptionGrid.get_child(i-1)
		c.pressed.connect(func(): 
			Event.choose_dialog_option.emit(i)
			has_option = false)
	$OptionTimer.timeout.connect(_on_optiontimer_timeout)
	
func hide_options():
	for c in $OptionGrid.get_children():
		c.hide()
	has_option = false
	
func show_options():
	if not dialog_data[dialog_index].option1:
		return
	has_option = true
	$OptionTimer.start()

func _on_optiontimer_timeout():
	for i in range(1,3):
		var opt = dialog_data[dialog_index]["option"+str(i)]
		if opt:
			var btn = $OptionGrid.get_child(i-1)
			btn.text = opt
			btn.show()
			if i==1:
				btn.grab_focus()
				
				
func move_by_vec(_vec):
	return false 
