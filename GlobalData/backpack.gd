extends Node

signal item_num_change(index, num)

@export var items = []
var num_empty = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	items.resize(5)
	num_empty = 5
	items[0] = {"name":"carrot", "amount":0}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func is_full():
	return num_empty > 0
	
func add_item(name):
	if name=="carrot":
		items[0].amount += 1
		item_num_change.emit(0, items[0].amount)

	
