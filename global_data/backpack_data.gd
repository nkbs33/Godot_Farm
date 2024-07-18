extends Node

@onready var global_data = get_parent()
@export var items = []
var num_empty = 0
const num_slots = 27

class Item:
	var name:String
	var num:int
	var node:Node
	
	func _init(name_="", num_=0, node_=null):
		name = name_
		num = num_
		node = node_

func _ready():
	items.resize(num_slots)
	num_empty = num_slots
	for i in range(num_slots):
		items[i] = Item.new()

func get_empty_slot():
	for i in range(num_slots):
		if items[i].num == 0:
			return i
	return -1

func find_item(name_):
	for i in range(num_slots):
		if items[i] and items[i].name == name_:
			return i
	return -1

func add_item(name_):
	var idx = find_item(name_)
	if idx >= 0:
		items[idx].num += 1
		Event.bag_item_change.emit(idx)
		return idx
	idx = get_empty_slot()
	if idx >= 0:
		items[idx].name = name_
		items[idx].num = 1
		Event.bag_item_change.emit(idx)
	return idx

func change_item_num(id, change):
	items[id].num += change
	Event.bag_item_change.emit(id)

func set_item_num(id, num_):
	items[id].num = num_
	Event.bag_item_change.emit(id)
