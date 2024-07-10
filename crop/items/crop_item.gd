extends Node2D
@export var item_name:String

var global_data
func _ready():
	$InteractiveRegion.s_interact_start.connect(on_interact)
	global_data = get_node("/root/GlobalData")
	
func on_interact():
	print("carrot_seed")
	global_data.pickup_item("carrot_seed")
