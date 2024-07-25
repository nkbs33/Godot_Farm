class_name World
extends Node2D

@onready var ground_tile_map = $GroundTileMap
@onready var crop_tile_map = $CropTileMap
var tile_focus

func _ready():
	Event.player_move.connect(track_player)
	tile_focus = get_node("UI/TileFocus")
	Event.player_pause.connect(func(): tile_focus.hide())
	Event.player_resume.connect(func(): tile_focus.show())
	GlobalData.world = self
	
func track_player(pos):
	var coord = get_coordinate(pos)
	GlobalData.player_coord = get_coordinate(pos)
	tile_focus.position = ground_tile_map.map_to_local(coord) - Vector2(8,8)

func get_coordinate(pos):
	return ground_tile_map.local_to_map(ground_tile_map.to_local(pos))

func turn_off_player_collision():
	ground_tile_map.tile_set.set_physics_layer_collision_mask(1, 0)

func turn_on_player_collision():
	ground_tile_map.tile_set.set_physics_layer_collision_mask(1, 1)

