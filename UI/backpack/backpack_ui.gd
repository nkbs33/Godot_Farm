extends Control

const NUM_SLOTS_ROW = 27
var slots
var focus = null

var background:bool
var selected_indices = []

@export var idx:int
@onready var item_menu = $ItemMenu

func set_idx(value):
	idx = (value + NUM_SLOTS_ROW)%NUM_SLOTS_ROW
	get_slot(idx).grab_focus()

func get_slot(idx):
	return slots.get_child((idx))

func _ready():
	slots = $Slots
	for i in range(slots.get_child_count()):
		var slot = slots.get_child(i)
		slot.id = i
		slot.focus_entered.connect(func(): idx = slot.id)
		slot.click.connect(func():
			slot.selected = true
			show_item_menu())
		
	$ItemMenu.hide()
	idx = 0
	connect_to_data()
	setup_item_menu()
	
func connect_to_data():
	var backpack_data = GlobalData.backpack
	Event.bag_item_change.connect(on_item_num_change)

func on_item_num_change(item):
	get_slot(item.index).item_name = item.name
	get_slot(item.index).num = item.num

func toggle_visible(vis):
	visible = vis
	$ItemMenu.toggle_visible(false)
	set_background(false)
	if vis:
		get_slot(idx).grab_focus() 
		Event.player_pause.emit()
	else:
		Event.player_resume.emit()

func set_background(val:bool):
	background = val
	if background:
		Event.player_resume.emit()
		modulate = Color(1,1,1,0.75)
	else:
		Event.player_pause.emit()
		modulate = Color(1,1,1,1)


func _physics_process(delta):
	if not visible or background or item_menu.visible:
		return
	var x = 0
	var y = 0
	if Input.is_action_just_pressed("ui_left"):
		x -= 1
	if Input.is_action_just_pressed("ui_right"):
		x += 1
	if Input.is_action_just_pressed("ui_down"):
		y += 1
	if Input.is_action_just_pressed("ui_up"):
		y -= 1
	if x!=0 or y!=0:
		set_idx(idx + x + y*9)

func _input(event):
	if event.is_action_pressed("switch_focus"):
		set_background(!background)
	if event.is_action_pressed("cancel") or event.is_action_pressed("backpack"):
		toggle_visible(false)
		get_viewport().set_input_as_handled()
	if background:
		return
	if event.is_action_pressed("accept"):
		show_item_menu()
		get_viewport().set_input_as_handled()


func show_item_menu():
	if get_slot(idx).num == 0:
		return
	$ItemMenu.set_global_position(get_slot(idx).global_position + Vector2(21,-14))
	Event.pre_item_menu_show.emit(idx, item_menu_entry_callback)
	$ItemMenu.toggle_visible(true)

func item_menu_entry_callback(entries):
	$ItemMenu.filter(entries)

func setup_item_menu():
	$ItemMenu.show_menu.connect(func():
		focus = $ItemMenu
	)
	$ItemMenu.hide_menu.connect(func(): 
		focus = null
		get_slot(idx).grab_focus()
		get_slot(idx).selected=false
	)
	$ItemMenu.add_entry("use", func(): print("use"))
	$ItemMenu.add_entry("equip", equip_item)
	$ItemMenu.add_entry("unequip", unequip_item)
	$ItemMenu.add_entry("split", func():print("split"))
	$ItemMenu.add_entry("destroy", func(): print("destroy"))
	$ItemMenu.add_entry("cancel", func(): 
		$ItemMenu.toggle_visible(false))

func equip_item():
	Event.equip_backpack_item.emit(idx)
	$ItemMenu.toggle_visible(false)
func unequip_item():
	Event.unequip_backpack_item.emit(idx)
	$ItemMenu.toggle_visible(false)
