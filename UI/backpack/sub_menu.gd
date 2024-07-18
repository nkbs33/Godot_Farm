class_name SubMenu
extends GridContainer

signal show_menu
signal hide_menu


var length:int = 3 
var current_entry:SubMenuItem
var entries = []

@export var entry_scene:PackedScene

@export var current_index:int:
	set(value):
		if current_entry:
			current_entry.focused = false
		current_index = (value+3)%3
		current_entry = get_entry(current_index)
		if current_entry:
			current_entry.focused = true

func add_entry(name_:String, callback):
	var entry = entry_scene.instantiate()
	entry.text = name_
	add_child(entry)

func get_entry(idx):
	return get_child(idx)

func _input(event):
	if not visible:
		return
	if event.is_action_pressed("accept"):
		get_viewport().set_input_as_handled()
		if current_entry.text == "use":
			pass
		elif current_entry.text == "equip":
			pass
			#Event.equip_backpack_item.emit(backpack.current_index)
		toggle_visible(false)
	elif event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		toggle_visible(false)

func move_by_vec(vec):
	current_index += vec.y
	return true

func toggle_visible(vis):
	visible = vis
	current_index = 0
	if vis:
		show_menu.emit()
	else:
		hide_menu.emit()
