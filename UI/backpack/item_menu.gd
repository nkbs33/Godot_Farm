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
		else:
			toggle_visible(false)
		if not backpack.check_valid(backpack.current_index):
			toggle_visible(false)
		
	if event.is_action_pressed("move_down"):
		current_index += 1
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("move_up"):
		current_index -= 1			
		get_viewport().set_input_as_handled()

func toggle_visible(vis):
	visible = vis
	if vis:
		backpack.focus = "item_submenu"
		current_index = 0
	else:
		backpack.focus = "slots"
