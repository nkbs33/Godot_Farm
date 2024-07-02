extends Control
signal exit

const NUM_SLOTS_ROW = 9
var focus = ""
var backpack_data
var slots
@onready var item_menu = get_node("BackpackPanel/ItemMenu")

@export var current_index:int:
	set(value):
		get_slot(current_index).selected = false
		current_index = (value + NUM_SLOTS_ROW)%NUM_SLOTS_ROW
		get_slot(current_index).selected = true
		item_menu.set_global_position(get_slot(current_index).global_position + Vector2(21,-14))
		toggle_item_menu(false)

func get_slot(idx):
	return slots.get_node("Slot_"+str(idx))

func _ready():
	slots = get_node("BackpackPanel/Slots")
	current_index = 0
	focus = "slots"
	connect_to_data()

func connect_to_data():
	backpack_data = get_node("/root/GlobalDataManager/BackpackData")
	backpack_data.item_num_change.connect(_on_backpack_item_num_change)
	backpack_data.add_item("carrot")

func _on_backpack_item_num_change(index, num):
	slots.get_node("Slot_"+str(index)).num = num

func close_self():
	item_menu.hide()
	exit.emit()


func toggle_item_menu(on):
	if item_menu.visible != on:
		item_menu.visible = on
	if on:
		focus = "item_submenu"
		item_menu.current_index = 0
	else:
		focus = "slots"


func reduce_item():
	backpack_data.change_item_num(current_index, -1)


func _unhandled_input(event):
	if not visible:
		return
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_LEFT:
				current_index -= 1
			if event.keycode == KEY_RIGHT:
				current_index += 1
			if event.keycode == KEY_SPACE:
				toggle_item_menu(!item_menu.visible)
			if event.keycode == KEY_ESCAPE and item_menu.visible:
				toggle_item_menu(false)
			if event.keycode == KEY_ESCAPE and focus == "slots":
				close_self()

func handle_action(action):
	pass 
