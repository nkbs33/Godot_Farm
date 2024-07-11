extends Node

@onready var player = get_parent()

func _input(event):
	if not player.input_enabled:
		return
	if event.is_action_pressed("interact"):
		player.interact()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("use_equipment"):
		player.use_equipment()
