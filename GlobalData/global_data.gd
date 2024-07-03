extends Node

# global references
var hud:CanvasLayer
var dialog_ui
var dialog_data = []
var player

# global function
func start_dialog(callback=null):
	dialog_ui.dialog_data = dialog_data
	hud.toggle_panel_by_name("dialog")
	if callback:
		dialog_ui.finish.connect(callback)
	dialog_ui.start_dialog()
