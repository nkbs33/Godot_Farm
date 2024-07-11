extends Node2D
@export var item_name:String
var global_data

func _ready():
	$InteractiveRegion.s_interact_start.connect(on_interact)
	global_data = get_node("/root/GlobalData")
	set_item_name(item_name)
	
	
func on_interact():
	global_data.backpack.add_item(item_name)

func set_item_name(v):
	item_name = v
	$Icon.item_name = v
