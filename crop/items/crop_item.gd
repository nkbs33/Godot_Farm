extends Node2D
@export var item_name:String

func _ready():
	set_item_name(item_name)
	$InteractiveRegion.s_interact_start.connect(on_interact)
	
func on_interact():
	GlobalData.backpack.add_item(item_name)

func set_item_name(v):
	item_name = v
	$Icon.item_name = v
