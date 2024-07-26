class_name ItemData
extends Node

var item_data = {}

func register(pos:Vector2, item:Node):
	var coord = GlobalData.world.get_coordinate(pos)
	item_data[coord] = item

func get_item(coord:Vector2i):
	return item_data.get(coord)
