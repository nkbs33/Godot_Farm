extends Node

@onready var player:Player = get_parent()

func _input(event):
	if player.paused:
		return
	if event.is_action_pressed("interact"):
		player.interact()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("use_equipment"):
		player.use_equipment()
