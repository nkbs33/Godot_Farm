class_name HUD
extends CanvasLayer

@onready var backpack = $Backpack
@onready var dialog = $Dialogue
var visible_elements = []

func _ready():
	GlobalData.hud = self
	Event.toggle_backpack.connect(on_toggle_backpack)

func on_toggle_backpack():
	$Backpack.toggle_visible(!$Backpack.visible)

func clear():
	for e in visible_elements:
		e.toggle_visible(false)
	visible_elements.clear()
