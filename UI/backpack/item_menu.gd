extends GridContainer

var length = 3 
var backpack
var current_entry

@export var current_index:int:
	set(value):
		if current_entry:
			current_entry.focused = false
		current_index = (value+3)%3
		current_entry = get_entry(current_index)
		current_entry.focused = true

func get_entry(idx):
	return get_node("Entry_"+str(idx))

func _input(event):
	if not visible:
		return
	if event.is_action_pressed("accept"):
		get_viewport().set_input_as_handled()
		if current_entry.text == "use":
			pass
			#backpack.use_item()
		elif current_entry.text == "equip":
			Event.equip_backpack_item.emit(backpack.current_index)
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
		backpack.focus = self
	else:
		backpack.focus = null
