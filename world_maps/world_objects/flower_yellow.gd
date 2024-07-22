extends Sprite2D

@export var npc_name = "yellow flower"
var dialog_data = []
var dialog_index = 0

var opt_request = ""
var opt = ""
var first_met = true

func _ready():
	$InteractiveRegion.interact_start.connect(on_interact)

func on_interact():
	if first_met:
		dialog_data = GlobalData.db_agent.query_dialog(npc_name, "context = 'first met'")
		first_met = false
	else:
		dialog_data = GlobalData.db_agent.query_dialog(npc_name, "context=''")
	dialog_index = -1
	get_next_index()
	Event.start_dialog.emit(dialog_data, dialog_index)
	Event.get_next_line.connect(_get_next_line)

func get_next_index():
	var line
	while true:
		dialog_index += 1
		if dialog_index >= dialog_data.size():
			break
		line = dialog_data[dialog_index]
		if line.condition==null or line.condition.substr(0,1)=="_" or line.condition == opt:
			break

func _get_next_line():
	get_next_index()
	
	if dialog_index >= dialog_data.size():
		Event.end_dialog.emit()
		Event.get_next_line.disconnect(_get_next_line)
		return
	
	var line = dialog_data[dialog_index]
	if line.condition and line.condition.substr(0,1) == "_":
		opt_request = line.condition.substr(1)+"-"
		print(opt_request)
		
	Event.show_next_line.emit(dialog_index)
	if dialog_data[dialog_index].option1:
		Event.choose_dialog_option.connect(_on_choose_dialog_option)

func _on_choose_dialog_option(idx):
	opt= opt_request+str(idx)
	print(opt)
	_get_next_line()
	Event.choose_dialog_option.disconnect(_on_choose_dialog_option)
