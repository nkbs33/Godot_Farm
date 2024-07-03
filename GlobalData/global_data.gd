extends Node

# global references
var hud:CanvasLayer
var dialog_ui
var dialog_data = []


# global function
func start_dialog():
	dialog_ui.dialog_data = dialog_data
	hud.toggle_panel_by_name("dialog")
	dialog_ui.start_dialog()
