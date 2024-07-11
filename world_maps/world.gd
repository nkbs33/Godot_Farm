extends Node2D

@onready var ground_tile_map = $GroundTileMap
@onready var crop_tile_map = $CropTileMap
@onready var tile_focus = get_node("UI/TileFocus")


func _ready():
	Event.player_move.connect(track_player)

func track_player(pos):
	var coord = ground_tile_map.local_to_map(ground_tile_map.to_local(pos))
	GlobalData.player_coord = coord
	tile_focus.position = ground_tile_map.map_to_local(coord) - Vector2(8,8)


func turn_off_player_collision():
	ground_tile_map.tile_set.set_physics_layer_collision_mask(1, 0)

func turn_on_player_collision():
	ground_tile_map.tile_set.set_physics_layer_collision_mask(1, 1)

