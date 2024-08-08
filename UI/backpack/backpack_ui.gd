class_name BackpackUI
extends Control

const NUM_SLOTS_ROW = 27
var slots

var background:bool
var selected_indices = []
var backpack_data:BackpackData

@export var idx:int
@onready var item_menu

func set_idx(value):
	idx = (value + NUM_SLOTS_ROW)%NUM_SLOTS_ROW
	get_slot(idx).grab_focus()

func get_slot(idx):
	return slots.get_child((idx))

func _ready():
	slots = $Slots
	item_menu = $ItemMenu
	for i in range(slots.get_child_count()):
		var slot = slots.get_child(i)
		slot.id = i
		slot.focus_entered.connect(func(): idx = slot.id)
		slot.click.connect(func():
			backpack_data.use(idx))
		
	item_menu.hide()
	idx = 0
	connect_to_data()
	setup_item_menu()
	
func connect_to_data():
	backpack_data = GlobalData.backpack
	backpack_data.bag_item_change.connect(_on_bag_item_change)

func _on_bag_item_change(item):
	get_slot(item.index).item_name = item.name
	get_slot(item.index).num = item.num

func toggle_visible(vis):
	if visible == vis: return
	visible = vis
	item_menu.toggle_visible(false)
	set_background(false)

func set_background(val:bool):
	background = val
	if background:
		modulate = Color(1,1,1,0.75)
	else:
		modulate = Color(1,1,1,1)


func _physics_process(delta):
	if not visible or background or item_menu.visible:
		return
	var vec = Vector2i(0,0)
	if Input.is_action_just_pressed("ui_left"):
		vec.x -= 1
	if Input.is_action_just_pressed("ui_right"):
		vec.x += 1
	if Input.is_action_just_pressed("ui_down"):
		vec.y += 1
	if Input.is_action_just_pressed("ui_up"):
		vec.y -= 1
	if vec != Vector2i(0,0):
		set_idx(idx + vec.x + vec.y * 9)

func _input(event):
	if event is InputEventMouse:
		return
	if visible and not item_menu.visible and event.is_action_pressed("cancel"):
		toggle_visible(false)

func show_item_menu():
	if get_slot(idx).num == 0:
		return
	item_menu.set_global_position(get_slot(idx).global_position + Vector2(21,-14))
	var entries = backpack_data.get_item_menu_entries(idx)
	item_menu.filter(entries)
	item_menu.toggle_visible(true)
	get_slot(idx).selected = true

func setup_item_menu():
	item_menu.visibility_changed.connect(_on_item_menu_visibility_changed)
	item_menu.add_entry("sell", func(): print("sell"))
	item_menu.add_entry("use", func(): print("use"))
	item_menu.add_entry("equip", equip_item)
	item_menu.add_entry("unequip", unequip_item)
	item_menu.add_entry("split", func():print("split"))
	item_menu.add_entry("destroy", func(): print("destroy"))
	item_menu.add_entry("cancel", func(): 
		item_menu.toggle_visible(false))

func _on_item_menu_visibility_changed():
	if item_menu.visible:
		for c:Control in slots.get_children():
			c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		get_slot(idx).grab_focus()
		get_slot(idx).selected = false
		for c:Control in slots.get_children():
			c.mouse_filter = Control.MOUSE_FILTER_PASS

func equip_item():
	backpack_data.equip_from_backpack(idx)
	item_menu.toggle_visible(false)
func unequip_item():
	backpack_data.unequip_from_backpack(idx)
	item_menu.toggle_visible(false)
