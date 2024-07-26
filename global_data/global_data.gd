extends Node

var hud:HUD
var player:Player
var world:World


@onready var crop_data:CropData = $CropData
@onready var backpack:BackpackData = $Backpack
@onready var db_agent = $DatabaseAgent
@onready var item_data:ItemData = $ItemData
var player_coord:Vector2i
var target

func set_player_coord(coord_):
	player_coord = coord_
	find_target()
	if target:
	#	print("t")
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func find_target():
	var item = item_data.get_item(player_coord)
	if item:
		target = item
		return
	var crop = crop_data.get_crop(player_coord)
	if crop:
		target = crop
		return
	target = null

func on_player_interact():
	var item = item_data.get_item(player_coord)
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
	#Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	#get_viewport().connect("gui_focus_changed", _on_focus_changed)

#func _on_focus_changed(control):
#	print("focus: ", control.name)
