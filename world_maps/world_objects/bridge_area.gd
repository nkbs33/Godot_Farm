extends Sprite2D  

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.set_collision_mask_value(3, 0)

func _on_body_exited(body):
	if body is CharacterBody2D:
		body.set_collision_mask_value(3, 1)

