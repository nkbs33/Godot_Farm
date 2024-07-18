extends PanelContainer

func _ready():
	Event.player_equip.connect(_on_player_equip)
	Event.player_unequip.connect(_on_player_unequip)

func _on_player_equip(equip_node):
	if get_child_count() > 0:
		get_child(0).queue_free()
	add_child(equip_node)
	equip_node.position = Vector2i(16,16)

func _on_player_unequip():
	if get_child_count() > 0:
		get_child(0).queue_free()
