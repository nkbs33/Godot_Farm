extends Node

var item_data = {}

func register(pos:Vector2, item:Node):
	var coord = GlobalData.world.get_coordinate(pos)
	item_data[coord] = item

func get_item(coord:Vector2i):
	if item_data.has(coord):
		return item_data[coord]
	return null
