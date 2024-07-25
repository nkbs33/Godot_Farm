extends Node

var hud:HUD
var player:Player
var player_coord:Vector2i
var world:World

@onready var crop_data = $CropData
@onready var backpack = $Backpack
@onready var db_agent = $DatabaseAgent


func on_player_interact():
	var item = $ItemData.get_item(player_coord)
	if item:
		item.on_interact()
		return
	
	var crop = crop_data.harvest_crop(player_coord)
	if not crop:
		return
	var idx = backpack.add_item(crop)
	if idx < 0: # fail
		return
	crop_data.remove_crop(player_coord)


#func _ready():
#	get_viewport().connect("gui_focus_changed", _on_focus_changed)

#func _on_focus_changed(control):
#	print("focus: ", control.name)
