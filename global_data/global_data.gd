extends Node

var hud:CanvasLayer
var dialog_ui
var player
var world
@onready var crop_data = $CropData
@onready var backpack = $Backpack
@onready var db_agent = $DatabaseAgent


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
	var crop = crop_data.harvest_crop(coord)
	if not crop:
		return
	var idx = backpack.add_item(crop)
	if idx < 0: # fail
		return
	crop_data.remove_crop(coord)


func use_backpack_item(idx):
	var item_name = backpack.items[idx].name
	#print("use "+item_name)	
	var item_data = db_agent.query_item_data(item_name)
	#if item_data.type == "seed":
	#	print("use seed: "+item_name)
	#	var crop_name = item_data.crop
	#	if crop_data.plant_crop(world.player_coord, crop_name) == 0:
	#		backpack.change_item_num(idx, -1)

func equip_backpack_item(idx):
	player.set_equipment(backpack.items[idx].name)
