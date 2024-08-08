class_name HouseArea
extends Area2D

@export var layer:int = -1
var has_player:bool

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
func on_body_entered(body):
	if not body is CharacterBody2D:
		return 
	has_player = true
	Event.player_enter_house.emit(layer)
	
func on_body_exited(body):
	if not body is CharacterBody2D:
		return 
	has_player = false
	Event.player_exit_house.emit(layer)
