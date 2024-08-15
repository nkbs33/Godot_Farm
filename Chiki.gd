extends Control

var npc_name:String = "奇奇"

func _gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		Event.start_dialog.emit(get_dialog_data())

func get_dialog_data():
	if GlobalData.global_state.get_character_state(npc_name, "first met") == null:
		GlobalData.global_state.set_character_state(npc_name, "first met", "false")
		return GlobalData.db_agent.query_dialog(npc_name, "context = 'first met'")
	return GlobalData.db_agent.query_dialog(npc_name, "context = ''")
