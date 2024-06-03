extends ColorRect

var focus = ""
var backpack_data

@export var current_index:int:
	set(value):
		$Slots.get_node("Slot_"+str(current_index)).selected = false
		current_index = value
		if current_index >= 5:
			current_index = 0
		if current_index < 0:
			current_index = 4
		$Slots.get_node("Slot_"+str(current_index)).selected = true
		$ItemMenu.set_global_position( $Slots.get_node("Slot_"+str(current_index)).global_position + Vector2(34,-100))
		toggle_item_menu(false)

func _ready():
	$ItemMenu.hide() 
	hide()
	backpack_data = get_node("/root/GlobalDataManager/BackpackData")
	backpack_data.item_num_change.connect(_on_backpack_item_num_change)
	current_index = 0
	focus = "slots"

func _on_backpack_item_num_change(index, num):
	$Slots.get_node("Slot_"+str(index)).num = num

func toggle_visible():
	$ItemMenu.hide()
	visible = !visible

func toggle_item_menu(on):
	if $ItemMenu.visible != on:
		$ItemMenu.visible = on
	if on:
		focus = "item_submenu"
	else:
		focus = "slots"
		
func reduce_item():
	backpack_data.change_item_num(current_index, -1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if not visible:
		return
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_LEFT:
				current_index -= 1
			if event.keycode == KEY_RIGHT:
				current_index += 1
			if event.keycode == KEY_SPACE and !$ItemMenu.visible:
				$ItemMenu.visible = true
				focus = "item_submenu"
			if event.keycode == KEY_ESCAPE and $ItemMenu.visible:
				$ItemMenu.visible = false
				focus = "slots"
			if event.keycode == KEY_ESCAPE and focus == "slots":
				toggle_visible()
