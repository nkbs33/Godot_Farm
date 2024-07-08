extends Node2D
@export var crop_stats: Resource
var crop_manager

func _ready():
	crop_manager = get_node("/root/GlobalData/Crops")

func _on_player_interact():
	$World.handle_interaction()
	
func _on_player_use_item(item):
	$World.handle_use_item(item)

func step_world():
	for coord in crop_manager.crops_data:
		var crops_name = crop_manager.crops_data[coord]
		if crops_name == "carrot_seed":
			crop_manager.set_crops(coord, "carrot", true)
