class_name World
extends Node2D

@onready var ground_tile_map = get_node("GroundTileMap/base_ground")
var tile_focus

func _ready():
	Event.player_move.connect(track_player)
	tile_focus = get_node("UI/TileFocus")
	Event.player_pause.connect(func(): tile_focus.hide())
	Event.player_resume.connect(func(): tile_focus.show())
	GlobalData.world = self
	
	Event.player_enter_house.connect(func(layer):
		ground_tile_map.set_layer_enabled(layer, false))
	Event.player_exit_house.connect(func(layer):
		ground_tile_map.set_layer_enabled(layer, true))
	
func track_player(pos):
	var coord = get_coordinate(pos)
	GlobalData.set_player_coord(coord)
	tile_focus.position = ground_tile_map.map_to_local(coord) - Vector2(8,8)

func get_coordinate(pos):
	return ground_tile_map.local_to_map(ground_tile_map.to_local(pos))

func turn_off_player_collision():
	ground_tile_map.tile_set.set_physics_layer_collision_mask(1, 0)

func turn_on_player_collision():
	ground_tile_map.tile_set.set_physics_layer_collision_mask(1, 1)
