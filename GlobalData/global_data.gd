extends Node

# ==== global references ====
# ui
var hud:CanvasLayer
var dialog_ui
var tile_focus
# game object
var player
var world

# global function
func start_dialog(dialog_data_, callback=null):
	dialog_ui.dialog_data = dialog_data_
	hud.toggle_panel_by_name("dialog")
	if callback:
		dialog_ui.finish.connect(callback)
	dialog_ui.start_dialog()
