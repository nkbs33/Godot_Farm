extends Sprite2D
@export var item_name:String

func _ready():
	var item_data = GlobalData.get_node("ItemData")
	await get_tree().create_timer(0.5).timeout
	item_data.register(global_position, self)
	
func on_interact():
	Event.pickup_item.emit(item_name)
