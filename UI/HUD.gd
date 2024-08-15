class_name HUD
extends CanvasLayer

@onready var backpack = $Backpack
@onready var dialog = $Dialogue

func _ready():
	GlobalData.hud = self
	Event.toggle_backpack.connect(on_toggle_backpack)
	Event.open_backpack_sell.connect(_on_open_backpack_sell)
	Event.close_backpack_sell.connect(_on_close_backpack_sell)
	
	Event.prompt_input.connect(_on_prompt_input)

func on_toggle_backpack():
	if $BackpackSell.visible:
		$BackpackSell.hide()
	$Backpack.toggle_visible(!$Backpack.visible)

func _on_open_backpack_sell():
	$Backpack.toggle_visible(false)
	$BackpackSell.toggle_visible(true)

func _on_close_backpack_sell():
	$BackpackSell.toggle_visible(false)

func _on_prompt_input(prompt, callback:Callable):
	if prompt == "{prompt_player_name}":
		%LineInput.make_input_dialog("你的名字是？","咪咪", func():
			GlobalData.global_var['player_name'] = %LineInput.value()
			callback.call())
		%LineInput.show()
