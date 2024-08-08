extends Control

var npc_name:String = "Chiki"

func _gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var dialog_data = GlobalData.db_agent.query_dialog(npc_name)
		Event.start_dialog.emit(dialog_data)
