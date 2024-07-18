class_name CropSeed
extends Node2D

@export var item_name:String
@export var crop_name:String

func _ready():
	set_item_name(item_name)
	
func on_use():
	Event.use_seed.emit(crop_name)

func set_item_name(v):
	item_name = v
	$Icon.item_name = v
