class_name Dialog
extends Control

@onready var hud:HUD = get_parent()
@onready var d_name = get_node("DialogBox/Name")
@onready var d_text = get_node("DialogBox/Text")

var dialog_data
var dialog_index:int
var line
var ch_name

		
@export var smooth_display_enabled:bool = true
@export var text_speed:float = 5.0
@export var comma_pause = 0.3
@export var period_pause = 0.5
var pause_timer = 0.0

var is_smooth_playing:bool = false
var smooth_play_timer:float

var has_option:bool = false
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
		if line.condition==null or line.condition=="": 
			break
		if line.condition.substr(0,1)=="#":
			opt_request = line.condition.substr(1)+"-"
			print("request option: ", opt_request)
			break
		var option_request = line.condition.split('-')[0]+'-'
		var option_chosen = GlobalData.global_state.get_character_state(ch_name, option_request)
		if line.condition == option_chosen:
			break
	update_dialog_box()

func choose_dialog_option(idx):
	var option_chosen = opt_request+str(idx)
	print("option chosen: ", option_chosen)
	GlobalData.global_state.set_character_state(ch_name, opt_request, option_chosen)
	get_next_line()

func update_dialog_box():
	hide_options()
	if dialog_index >= dialog_data.size():
		return
	line = dialog_data[dialog_index]
	ch_name = line["name"]
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
		if GlobalData.global_var.has(r):
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
	if pause_timer > 0:
		pause_timer -= delta
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
	else:
		var char = d_text.text[d_text.visible_characters-1]
		if char == '，':
			pause_timer = comma_pause
		elif char == '。' or char == '？':
			pause_timer = period_pause

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
