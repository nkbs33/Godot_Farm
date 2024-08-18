extends Control

var npc_name:String = "奇奇"
@export var dialog_id:int = 1

func _ready():
	Event.dialog_event.connect(_on_dialog_event)

func _on_dialog_event(event):
	if event == "start_tutorial":
		print("start tutorial")
		StageManager.current_stage = "tutorial"

func _gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var data = get_dialog_data()
		Event.start_dialog.emit(data)

func get_dialog_data():
	if GlobalData.global_state.get_character_state(npc_name, "first met") == null:
		GlobalData.global_state.set_character_state(npc_name, "first met", "false")
		dialog_id = DialogData.query_dialog(npc_name, "first met")[0].id
	elif StageManager.current_stage== "tutorial":
		dialog_id = DialogData.query_dialog(npc_name, "tutorial")[0].id
	else:
		dialog_id = DialogData.query_dialog(npc_name, "intro")[0].id
		
	return DialogData.get_dialog(dialog_id)
