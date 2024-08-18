class_name Dialog
extends Control

var dialog_data
var dialog_id:int
		
var has_option:bool = false
var opt_chosen:int

func _ready():
	Event.start_dialog.connect(_on_start_dialog)
	setup_options()
	%DialogBox.display_finished.connect(func(): check_input())
	
	
func toggle_visible(vis):
	visible = vis
	
func _on_start_dialog(dialog_data_):
	Event.player_pause.emit()
	toggle_visible(true)
	dialog_data = dialog_data_
	dialog_id = dialog_data.id
	update_dialog_box()

func end_dialog():
	toggle_visible(false)
	Event.player_resume.emit()

func _gui_input(event):
	if %DialogBox.is_playing or has_option:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("cancel"):
		get_next_line()
		get_viewport().set_input_as_handled()

func get_next_line():
	has_option = false
	if dialog_data.next_id == "0":
		end_dialog()
		if dialog_data.event:
			Event.dialog_event.emit(dialog_data.event)
		return
	if dialog_data.next_id:
		if opt_chosen >= 0:
			var ids = dialog_data.next_id.split(";")
			dialog_id = int(ids[opt_chosen])
		else:
			dialog_id = int(dialog_data.next_id)
	else:
		dialog_id += 1
	dialog_data = DialogData.query_dialog_by_id(dialog_id)	
	update_dialog_box()


func update_dialog_box():
	%DialogBox.set_data(dialog_data.name, replace_vars(dialog_data.text))
	%DialogBox.start_display()
	
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


func setup_options():
	for i in range(3):
		var c = %OptionGrid.get_child(i)
		c.pressed.connect(func(): 
			opt_chosen = i
			get_next_line())
	%OptionTimer.timeout.connect(_on_optiontimer_timeout)

func check_input():
	if not dialog_data.options:
		return
	has_option = true
	%OptionTimer.start()

func _on_optiontimer_timeout():
	var options:String = dialog_data.options
	if options.begins_with("{prompt"):
		handle_prompt(options)
	else:
		var opt_arr = options.split(";")
		show_options(opt_arr)

func handle_prompt(prompt):
	Event.prompt_input.emit(prompt, func():
		get_next_line())

func show_options(opt_arr):
	for i in range(opt_arr.size()):
		var opt = opt_arr[i]		
		var btn = %OptionGrid.get_child(i)
		btn.text = opt
		btn.show()
