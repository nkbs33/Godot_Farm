extends Node2D
@export var crop_stats: Resource
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_query_coords(world_pos):
	$World.respond(world_pos)	


func _on_player_interact():
	var target = $World.handle_interaction()
	

func _on_player_use_item(item):
	var target = $World.handle_use_item(item)



func step_world():
	var crop_manager = get_node("/root/GlobalDataManager/CropsManager")
	for coord in crop_manager.crops_data:
		var crops_name = crop_manager.crops_data[coord]
		if crops_name == "carrot_seed":
			crop_manager.set_crops(coord, "carrot", true)
