extends Node2D

@onready var global_data = get_node("/root/GlobalData")
@export var dialog_data = []

func _ready():
	var ir = get_parent().get_node("InteractiveRegion")
	if not ir:
		return
	ir.s_interact_start.connect(on_interact)

func on_interact():
	if dialog_data.size() > 0:
		Event.end_dialog.connect(on_dialog_end)
		Event.start_dialog.emit(dialog_data)

func on_dialog_end():
	print("dialog end")
	Event.end_dialog.disconnect(on_dialog_end)
