extends GridContainer

var length = 3 
@export var current_index:int:
	set(value):
		get_node("Entry_"+str(current_index) + "/SelectBox").hide()
		current_index = value
		if current_index >= length:
			current_index = 0
		if current_index < 0:
			current_index = length-1
		get_node("Entry_"+str(current_index) + "/SelectBox").show()
			
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
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
				print(get_node("Entry_"+str(current_index) + "/Label").text)
				
				if current_index == 0 or current_index == 1:
					get_parent().reduce_item()
				if current_index == length-1:
					get_parent().toggle_item_menu(false)
				get_viewport().set_input_as_handled()
