class_name Dialog
extends Control

@onready var hud:HUD = get_parent()
@onready var d_name = $DialogBox.get_node("Name")
@onready var d_text = $DialogBox.get_node("Text")

var dialog_data
var dialog_index:int
		
@export var smooth_display_enabled:bool = true
@export var text_speed = 5
var is_smooth_playing:bool = false
var smooth_play_timer:float

var has_option:bool = false
var option_chosen:String
var opt_request:String

func _ready():
	Event.start_dialog.connect(_on_start_dialog)
	setup_options()

func toggle_visible(vis):
	visible = vis
	
func _on_start_dialog(dialog_data_):
	if not dialog_data_ or dialog_data_.size()==0:
		return
	Event.player_pause.emit()
	toggle_visible(true)
	dialog_data = dialog_data_
	dialog_index = -1
	get_next_line()

func end_dialog():
	toggle_visible(false)
	Event.player_resume.emit()

func _gui_input(event):
	if is_smooth_playing or has_option:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("cancel"):
		get_next_line()
		get_viewport().set_input_as_handled()

func get_next_line():
	print("next")
	while true:
		dialog_index += 1
		if dialog_index >= dialog_data.size():
			end_dialog()
			return
		var line = dialog_data[dialog_index]
		if line.condition==null: 
			break
		if line.condition.substr(0,1)=="_":
			opt_request = line.condition.substr(1)+"-"
			print("request option: ", opt_request)
			break
		if line.condition == option_chosen:
			break
	update_dialog_box()

func choose_dialog_option(idx):
	option_chosen = opt_request+str(idx)
	print("option chosen: ", option_chosen)
	get_next_line()

func update_dialog_box():
	hide_options()
	if dialog_index >= dialog_data.size():
		return
	var line = dialog_data[dialog_index]
	d_name.text = "[center]" + line["name"] + "[/center]"
	# replace vars
	d_text.text = replace_vars(line["text"])
	start_display()
	
func replace_vars(str:String):
	var matches = []
	var regex = RegEx.new()
	regex.compile("\\{([^\\{\\}]*)\\}");
	var match = regex.search(str)
	if match != null:
		var r = match.get_string(1)
		str = str.replace("{"+r+"}", GlobalData.global_var[r])
	return str

func start_display():
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
		step_dialog_display()
		smooth_play_timer -= 0.05/text_speed

func step_dialog_display():
	d_text.visible_characters += 1
	if d_text.visible_characters >= d_text.text.length():
		is_smooth_playing = false
		check_input()

func setup_options():
	for i in range(1,3):
		var c = $OptionGrid.get_child(i-1)
		c.pressed.connect(func(): 
			choose_dialog_option(i)
			has_option = false)
	$OptionTimer.timeout.connect(_on_optiontimer_timeout)
	
func hide_options():
	for c in $OptionGrid.get_children():
		c.hide()
	has_option = false
	
func check_input():
	if not dialog_data[dialog_index].option1:
		return
	has_option = true
	$OptionTimer.start()

func _on_optiontimer_timeout():
	# check prompt
	var line_data = dialog_data[dialog_index]
	var opt1:String = line_data["option1"]
	if opt1.begins_with("{prompt"):
		handle_prompt(opt1)
		return
	for i in range(1,3):
		var opt = line_data["option"+str(i)]
		if opt:
			var btn = $OptionGrid.get_child(i-1)
			btn.text = opt
			btn.show()

func handle_prompt(opt1):
	Event.prompt_input.emit(opt1, func():
		has_option = false
		get_next_line())
