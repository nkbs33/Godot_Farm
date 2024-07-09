extends Node2D

@onready var ground_tile_map = $GroundTileMap
@onready var crop_tile_map = $CropTileMap
@onready var tile_focus = get_node("UI/TileFocus")
var global_data
var player_coord = Vector2i(0,0)

func _ready():
	global_data = get_node("/root/GlobalData")
	global_data.world = self

func _process(_delta):
	track_player()

func track_player():
	if global_data.player == null:
		return
	var player_pos = global_data.player.effective_pos()
	player_coord = ground_tile_map.local_to_map(ground_tile_map.to_local(player_pos))
	tile_focus.position = ground_tile_map.map_to_local(player_coord) - Vector2(8,8)

func set_crop():	
	var atlas = Vector2i(3, 7)
	crop_tile_map.set_crop(player_coord, atlas)
	
func handle_interaction():
	crop_tile_map.handle_interaction(player_coord)

func turn_off_player_collision():
	ground_tile_map.tile_set.set_physics_layer_collision_mask(1, 0)

func turn_on_player_collision():
	ground_tile_map.tile_set.set_physics_layer_collision_mask(1, 1)
