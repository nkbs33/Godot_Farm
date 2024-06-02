extends ColorRect

@export var num:int:
	set(value):
		num = value
		$Number.text = str(num)
		on_num_change()

# Called when the node enters the scene tree for the first time.
func _ready():
	on_num_change()

func on_num_change():
	if num == 0:
		$Image.hide()
		$Number.hide()
	else:
		$Image.show()
		$Number.show()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
