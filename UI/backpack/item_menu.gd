extends GridContainer

var length = 3 
@onready var backpack = get_parent().get_parent()

@export var current_index:int:
	set(value):
		get_node("Entry_"+str(current_index) + "/SelectBox").hide()
		current_index = (value+3)%3
		get_node("Entry_"+str(current_index) + "/SelectBox").show()
	
func _unhandled_input(event):
	if not visible:
		return
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_UP:
				current_index -= 1
				get_viewport().set_input_as_handled()
			if event.keycode == KEY_DOWN:
				current_index += 1
				get_viewport().set_input_as_handled()
			if event.keycode == KEY_SPACE:
				print(get_node("Entry_"+str(current_index)).text)
				
				if current_index == 0 or current_index == 1:
					backpack.reduce_item()
				if current_index == length-1:
					backpack.toggle_item_menu(false)
				get_viewport().set_input_as_handled()
