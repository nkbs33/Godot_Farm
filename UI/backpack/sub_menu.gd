class_name SubMenu
extends GridContainer

signal show_menu
signal hide_menu

var entries = []
var entry_dict = {}
var entries_visible = []

@export var entry_scene:PackedScene

func add_entry(name_:String, callback):
	var entry = entry_scene.instantiate()
	entry.focus_entered.connect(func():print("focus ", name_))
	entry.name = name_
	entry.text = name_
	entry.pressed.connect(callback)
	add_child(entry)
	entries.append(entry)
	entry_dict[name_] = entry
	if entries.size()>1:
		entries[entries.size()-2].focus_neighbor_bottom=""
		entry.focus_neighbor_bottom=entries[0].get_path()
		entries[0].focus_neighbor_top = entry.get_path()

func filter(entries_shown):
	for e in entries:
		e.hide()
	entries_visible.clear()
	for e in entries_shown:
		if entry_dict.has(e):
			entry_dict[e].show()
			entries_visible.append(entry_dict[e])
	if entries_visible.size()>1:
		entries_visible[-1].focus_neighbor_bottom = entries_visible[0].get_path()
		entries_visible[0].focus_neighbor_top = entries_visible[-1].get_path()

func _input(event):
	if not visible:
		return
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		toggle_visible(false)

func toggle_visible(vis):
	visible = vis
	if vis:
		entries_visible[0].grab_focus()
		show_menu.emit()
	else:
		hide_menu.emit()
