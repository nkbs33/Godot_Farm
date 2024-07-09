extends Node

var hud:CanvasLayer
var dialog_ui
var player
var world
@onready var crop_data = $CropData
@onready var backpack = $Backpack


func start_dialog(dialog_data_, callback=null):
	dialog_ui.dialog_data = dialog_data_
	hud.toggle_panel_by_name("dialog")
	if callback:
		dialog_ui.finish.connect(callback)
	dialog_ui.start_dialog()

func on_player_interact():
	if not world:
		return
	var coord = world.player_coord
	var crop = crop_data.get_crop(coord)
	if not crop:
		return
	var idx = backpack.add_item(crop)
	if idx < 0: # fail
		return
	crop_data.remove_crop(coord)

func set_crop():
	crop_data.set_crop(world.player_coord, "cabbage")
