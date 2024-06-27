extends Node2D
@export var crop_stats: Resource
var crop_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	crop_manager = get_node("/root/GlobalDataManager/CropsManager")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Player:
		$World.set_player_position($Player.effective_position)	

func _on_player_interact():
	var target = $World.handle_interaction()
	

func _on_player_use_item(item):
	var target = $World.handle_use_item(item)



func step_world():
	for coord in crop_manager.crops_data:
		var crops_name = crop_manager.crops_data[coord]
		if crops_name == "carrot_seed":
			crop_manager.set_crops(coord, "carrot", true)
