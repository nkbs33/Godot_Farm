class_name SubMenuItem
extends Button

var focused:bool:
	set(val):
		focused = val
		$SelectBox.visible = val
