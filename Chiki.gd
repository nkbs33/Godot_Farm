extends Control

var npc_name:String = "奇奇"
@export var dialog_id:int = 1

func _ready():
	Event.dialog_event.connect(_on_dialog_event)
	set_default_cursor_shape(Control.CURSOR_POINTING_HAND)

func _on_dialog_event(event):
	if event == "start_tutorial":
		print("start tutorial")
		StageManager.current_stage = "tutorial"

func _gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var data = get_dialog_data()
		Event.start_dialog.emit(data)

func get_dialog_data():
	dialog_id = StageManager.get_dialog_id(npc_name)
	return DialogData.get_dialog(dialog_id)
