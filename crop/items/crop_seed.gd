extends Node2D
@export var item_name:String
@export var crop_name:String

func _ready():
	set_item_name(item_name)
	
func on_use():
	GlobalData.crop_data.plant_crop(GlobalData.player_coord, crop_name)

func set_item_name(v):
	item_name = v
	$Icon.item_name = v
