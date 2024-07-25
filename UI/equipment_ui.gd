extends PanelContainer

var equipment:Node

func _ready():
	Event.player_equip.connect(_on_player_equip)
	Event.player_unequip.connect(_on_player_unequip)
	Event.equipment_num_change.connect(func(num): 
		get_node("Control/Number").text = str(num)
		get_node("Control/Number").visible = num>0 and equipment.consume)

func _on_player_equip(equip_node):
	equipment = equip_node
	if get_child_count() > 1:
		get_child(1).queue_free()
	add_child(equipment)
	equipment.position = Vector2i(16,16)

func _on_player_unequip():
	if get_child_count() > 1:
		get_child(1).queue_free()
		get_node("Control/Number").hide()
