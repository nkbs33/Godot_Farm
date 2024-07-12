extends Control

@onready var image = $Container.get_node("Image")
@onready var number = $Container.get_node("Number")
@onready var bg = $Container.get_node("Background")
@onready var select_box = $Container.get_node("SelectBox")

@export var item_name:String
@export var num:int:
	set(value):
		num = value
		number.text = str(num)
		on_num_change()

var selected:bool:
	set(value):
		selected = value
		if value:
			$Container.scale = Vector2(1.3, 1.3)
			$Container.position = Vector2(0,-1)
			select_box.show()
		else:
			$Container.scale = Vector2(1, 1)
			$Container.position = Vector2(0,0)
			select_box.hide()
			
func _ready():
	on_num_change()

func on_num_change():
	image.visible = num > 0
	number.visible = num > 1
	bg.visible = num == 0
	image.item_name = item_name
	
		
