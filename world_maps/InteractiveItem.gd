extends Node2D
signal item_interact

func _ready():
	var item_data = GlobalData.get_node("ItemData")
	await get_tree().create_timer(0.5).timeout
	item_data.register(global_position, self)
	
func on_interact():
	item_interact.emit()
