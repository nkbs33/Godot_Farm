extends Control

func _gui_input(event):
	if not $InteractiveRegion.has_player:
		return
	if event is InputEventMouseButton and event.is_pressed():
		_on_click()

func _on_click():
	print("click work station")
	var dialog_data = GlobalData.db_agent.query_dialog("work station")
	Event.start_dialog.emit(dialog_data)
