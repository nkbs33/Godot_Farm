class_name InteractiveRegion
extends Area2D

signal interact_start
signal interact_end

signal player_enter
signal player_exit

var has_player:bool

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
func on_body_entered(body):
	if not body is CharacterBody2D:
		return 
	has_player = true
	body.add_interactable(self)
	player_enter.emit()
	
func on_body_exited(body):
	if not body is CharacterBody2D:
		return 
	has_player = false
	body.remove_interactable(self)
	player_exit.emit()

func on_interact():
	interact_start.emit()
