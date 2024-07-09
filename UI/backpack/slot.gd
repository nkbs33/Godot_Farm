extends Control

@onready var image = $Container.get_node("Image")
@onready var number = $Container.get_node("Number")
@onready var bg = $Container.get_node("Background")

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
			#print(scale)
		else:
			$Container.scale = Vector2(1, 1)

func _ready():
	on_num_change()

func on_num_change():
	if num == 0:
		image.hide()
		number.hide()
		bg.show()
	else:
		image.item_name = item_name
		bg.hide()
		image.show()
		if num == 1:
			number.hide()
		else:
			number.show()
		
