extends Control

const NUM_SLOTS_ROW = 27
var hud:HUD
var backpack_data
var slots
var item_menu
var focus = null

var background:bool

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

func connect_to_data():
	backpack_data = GlobalData.backpack
	Event.bag_item_change.connect(on_item_num_change)

func on_item_num_change(index):
	get_slot(index).item_name = backpack_data.items[index].name
	get_slot(index).num = backpack_data.items[index].amount

func toggle_visible(vis):
	visible = vis
	item_menu.toggle_visible(false)
	hud.occupied_by = self if vis else null
	set_background(false)
	if vis:
		Event.player_pause.emit()
	else:
		Event.player_resume.emit()

func set_background(val:bool):
	background = val
	if background:
		Event.player_resume.emit()
		$BackpackPanel.modulate = Color(1,1,1,0.75)
	else:
		Event.player_pause.emit()
		$BackpackPanel.modulate = Color(1,1,1,1)

func move_by_vec(vec):
	current_index += vec.x
	current_index += vec.y * 9
	
func _process(delta):
	if visible and not background and not hud.move_vec == Vector2(0,0):
		if not item_menu.visible:
			move_by_vec(hud.move_vec)
		else:
			item_menu.move_by_vec(hud.move_vec)
		Event.move_in_ui.emit()

func _input(event):
	if not visible or item_menu.visible:
		return
	if event.is_action_pressed("switch_focus"):
		set_background(!background)
	if event.is_action_pressed("cancel") or event.is_action_pressed("backpack"):
		toggle_visible(false)
		get_viewport().set_input_as_handled()
	if background:
		return
	if event.is_action_pressed("accept"):
		if check_valid(current_index):
			item_menu.toggle_visible(true)
			focus = item_menu
