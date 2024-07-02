extends Panel

@export var text = "item"

func _ready():
	$Label.text = "[center]"+text+"[/center]"
