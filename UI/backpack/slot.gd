extends Control

signal click

var id:int
@onready var image = $Container.get_node("Image")
@onready var number = $Container.get_node("Number")
@onready var bg = $Container.get_node("Background")
@onready var select_box = $Container.get_node("SelectBox")
@onready var backpack_ui = get_parent().get_parent()

@export var item_name:String
@export var num:int:
	set(value):
		num = value
		number.text = str(num)
		on_num_change()

var selected:bool:
	set(value):
		selected = value
		update_render()
		
			
func update_render():
	if selected or has_focus():
		$Container.scale = Vector2(1.3, 1.3)
		$Container.position = Vector2(0,-1)
		select_box.show()
	else:
		$Container.scale = Vector2(1, 1)
		$Container.position = Vector2(0,0)
		select_box.hide()			
			
func _ready():
	on_num_change()
	focus_entered.connect(update_render)
	focus_exited.connect(update_render)
	
	mouse_entered.connect(func():
		grab_focus())
	mouse_exited.connect(func():
		release_focus())

func on_num_change():
	image.visible = num > 0
	number.visible = num > 1
	bg.visible = num == 0
	image.update_sprite(item_name)

func _gui_input(event):
	if event is InputEventMouseButton and event.is_released() and has_focus():
		click.emit()
	
