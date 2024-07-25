extends Sprite2D

func _ready():
	$InteractiveRegion.player_enter.connect(_on_player_enter)
	$InteractiveRegion.player_exit.connect(_on_player_exit)
	$InteractiveRegion.interact_start.connect(_on_interact_start)

func _on_interact_start():
	Event.open_backpack_sell_mode.emit()

func _on_player_enter():
	$AnimationPlayer.play("open")

func _on_player_exit():
	$AnimationPlayer.play("open", -1, -1, true)
	
