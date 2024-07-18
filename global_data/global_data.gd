extends Node

var hud:HUD
var player
var player_coord

@onready var crop_data:CropData = $CropData
@onready var backpack = $Backpack
@onready var db_agent = $DatabaseAgent


func on_player_interact():
	var crop = crop_data.harvest_crop(player_coord)
	if not crop:
		return
	var idx = backpack.add_item(crop)
	if idx < 0: # fail
		return
	crop_data.remove_crop(player_coord)

func equip_backpack_item(idx):
	player.set_equipment(backpack.items[idx].name)


