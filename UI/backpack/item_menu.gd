extends GridContainer

var length = 3 
@onready var backpack = get_parent().get_parent()

@export var current_index:int:
	set(value):
		get_node("Entry_"+str(current_index) + "/SelectBox").hide()
		current_index = (value+3)%3
		get_node("Entry_"+str(current_index) + "/SelectBox").show()

func _input(event):
	if not visible:
		return
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		if current_index == 0:
			backpack.reduce_item()
		toggle_visible(false)
		if not backpack.check_valid(backpack.current_index):
			toggle_visible(false)
	elif event.is_action_pressed("ui_cancel"):
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
