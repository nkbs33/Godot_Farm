extends Control

const NUM_SLOTS_ROW = 9
var hud
var backpack_data
var slots
var item_menu
var focus = null

@export var current_index:int:
	set(value):
		get_slot(current_index).selected = false
		current_index = (value + NUM_SLOTS_ROW)%NUM_SLOTS_ROW
		get_slot(current_index).selected = true
		item_menu.set_global_position(get_slot(current_index).global_position + Vector2(21,-14))
		item_menu.toggle_visible(false)

func get_slot(idx):
	return slots.get_child((idx))
func get_item_data(idx):
	return backpack_data.items[idx]
func check_valid(idx):
	var item_data = get_item_data(idx)
	return item_data != null and item_data.amount > 0

func _ready():
	slots = get_node("BackpackPanel/Slots")
	item_menu = get_node("BackpackPanel/ItemMenu")
	item_menu.hide()
	item_menu.backpack = self
	current_index = 0
	connect_to_data()
	hud = get_parent()

func connect_to_data():
	backpack_data = get_node("/root/GlobalData/Backpack")
	backpack_data.item_num_change.connect(_on_backpack_item_num_change)

func _on_backpack_item_num_change(index):
	get_slot(index).item_name = backpack_data.items[index].name
	get_slot(index).num = backpack_data.items[index].amount

func toggle_visible(vis):
	item_menu.toggle_visible(false)
	visible = vis
	hud.focus = self if vis else null
	
func reduce_item():
	backpack_data.change_item_num(current_index, -1)

func move_by_vec(vec):
	if not visible:
		return false
	if focus:
		return focus.move_by_vec(vec)
	current_index += vec.x
	return true 
	
func _input(event):
	if not visible or focus:
		return
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("backpack"):
		toggle_visible(false)
	if event.is_action_pressed("interact"):
		if check_valid(current_index):
			item_menu.toggle_visible(true)
			focus = item_menu

func handle_action(action):
	pass 
