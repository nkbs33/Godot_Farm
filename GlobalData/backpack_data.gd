extends Node

signal item_num_change(index, num)

@export var items = []
var num_empty = 0
const NUM_SLOTS = 32

# Called when the node enters the scene tree for the first time.
func _ready():
	items.resize(NUM_SLOTS)
	num_empty = NUM_SLOTS
	items[0] = {"name":"carrot", "amount":0}
	items[1] = {"name":"carrot", "amount":0}

func is_full():
	return num_empty > 0
	
func add_item(name):
	if name=="carrot":
		items[0].amount += 1
		item_num_change.emit(0, items[0].amount)

func change_item_num(id, change):
	items[id].amount += change
	item_num_change.emit(id, items[id].amount)

func set_item_num(id, num_):
	items[id].amount = num_
	item_num_change.emit(id, num_)
