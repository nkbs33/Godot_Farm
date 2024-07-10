extends Panel

@export var text = "item"
var focused:bool:
	set(val):
		focused = val
		$SelectBox.visible = val

func _ready():
	$Label.text = "[center]"+text+"[/center]"
