extends Node

signal item_num_change(index)

@onready var global_data = get_parent()
@export var items = []
var num_empty = 0
const num_slots = 9


func make_item(name_="", amount_=0, node_=null):
	return {
		"name": name_,
		"amount": amount_,
		"node": node_
	}

func _ready():
	items.resize(num_slots)
	num_empty = num_slots
	for i in range(num_slots):
		items[i] = make_item()

func get_empty_slot():
	for i in range(num_slots):
		if items[i].amount == 0:
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
		items[idx].amount += 1
		item_num_change.emit(idx)
		return idx
	idx = get_empty_slot()
	if idx >= 0:
		items[idx].name = name_
		items[idx].amount = 1
		item_num_change.emit(idx)
	return idx

func change_item_num(id, change):
	items[id].amount += change
	item_num_change.emit(id)

func set_item_num(id, num_):
	items[id].amount = num_
	item_num_change.emit(id)
