extends Control

const NUM_SLOTS_ROW = 27
var hud
var global_data
var backpack_data
var slots
var item_menu
var focus = null
var isFocused:bool

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

func get_current_item():
	return backpack_data.items[current_index]

func _ready():
	slots = get_node("BackpackPanel/Slots")
	item_menu = get_node("BackpackPanel/ItemMenu")
	item_menu.hide()
	item_menu.backpack = self
	current_index = 0
	connect_to_data()
	hud = get_parent()
	toggle_visible(false)

func connect_to_data():
	global_data = get_node("/root/GlobalData")
	backpack_data = global_data.backpack
	backpack_data.item_num_change.connect(_on_item_num_change)

func _on_item_num_change(index):
	get_slot(index).item_name = backpack_data.items[index].name
	get_slot(index).num = backpack_data.items[index].amount

func toggle_visible(vis):
	isFocused = vis
	item_menu.toggle_visible(false)
	modulate = Color(1,1,1,1) if vis else Color(1,1,1,0.75)
	$BackpackPanel.scale = Vector2(1,1) if vis else Vector2(0.8, 0.8)
	hud.focus = self if vis else null
	
func use_item():
	global_data.use_backpack_item(current_index)

func equip_item():
	global_data.equip_backpack_item(current_index)

func move_by_vec(vec):
	if not visible:
		return false
	if focus:
		return focus.move_by_vec(vec)
	current_index += vec.x
	current_index += vec.y * 9
	return true 
	
func _input(event):
	if not isFocused or focus:
		return
	if event.is_action_pressed("cancel") or event.is_action_pressed("backpack"):
		toggle_visible(false)
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("accept"):
		if check_valid(current_index):
			item_menu.toggle_visible(true)
			focus = item_menu

func handle_action(_action):
	pass 
