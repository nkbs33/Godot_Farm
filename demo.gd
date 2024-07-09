extends Node2D
@export var crop_stats: Resource
var crop_manager


func _on_player_use_item(item):
	$World.handle_use_item(item)
