extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	Event.player_equip.connect(on_equip)


func on_equip(equip_node):
	var ex = get_child(0)
	if ex:
		ex.queue_free()
	add_child(equip_node)
	equip_node.position = Vector2i(16,16)
