extends Sprite2D

func _ready():
	$InteractiveRegion.player_enter.connect(_on_player_enter)
	$InteractiveRegion.player_exit.connect(_on_player_exit)
	$InteractiveItem.item_interact.connect(_on_item_interact)

func _on_item_interact():
	Event.open_backpack_sell.emit()

func _on_player_enter():
	$AnimationPlayer.play("open")

func _on_player_exit():
	$AnimationPlayer.play("open", -1, -1, true)
	Event.close_backpack_sell.emit()
	
