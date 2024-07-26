class_name CropSeed
extends Node2D

@export var item_name:String
@export var crop_name:String
@export var consume:bool = true

func _ready():
	$Icon.update_sprite(item_name)
	
func on_use():
	Event.use_seed.emit(crop_name)
