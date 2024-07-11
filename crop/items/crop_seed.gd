extends Node2D
@export var item_name:String
@export var crop_name:String
var global_data

func _ready():
	global_data = get_node("/root/GlobalData")
	set_item_name(item_name)
	
func on_use():
	global_data.crop_data.plant_crop(global_data.world.player_coord, crop_name)

func set_item_name(v):
	item_name = v
	$Icon.item_name = v
