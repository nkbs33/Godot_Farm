class_name BackpackUISell
extends Control

const NUM_SLOTS_ROW = 27
var slots
var backpack_data:BackpackData

@export var idx:int

func set_idx(value):
	idx = (value + NUM_SLOTS_ROW)%NUM_SLOTS_ROW
	get_slot(idx).grab_focus()

func get_slot(idx):
	return slots.get_child((idx))

func _ready():
	idx = 0
	setup_slots()
	connect_to_data()
	
func setup_slots():
	slots = $Slots
	for i in range(slots.get_child_count()):
		var slot = slots.get_child(i)
		slot.id = i
		slot.focus_entered.connect(func(): idx = slot.id)
		slot.click.connect(_on_sell_item)

func connect_to_data():
	backpack_data = GlobalData.backpack
	backpack_data.bag_item_change.connect(_on_bag_item_change)

func _on_bag_item_change(item):
	get_slot(item.index).item_name = item.name
	get_slot(item.index).num = item.num

func toggle_visible(vis):
	if visible == vis:
		return
	visible = vis

func _input(event):
	if visible and event.is_action_pressed("cancel"):
		toggle_visible(false)

func _on_sell_item():
	var item:BackpackData.Item = backpack_data.items[idx]
	var sum = item.value * item.num
	print("sell %s %s" % [item.name, sum])
	backpack_data.money += sum
	backpack_data.set_item_num(idx, 0)
