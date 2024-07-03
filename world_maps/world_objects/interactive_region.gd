extends Area2D

@export var text:String = "interactive region placehold"
var hasPlayer:bool = false 
var player = null
@onready var global_data = get_node("/root/GlobalData")

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
func on_body_entered(body):
	if not body is CharacterBody2D:
		return 
	player = body
	body.add_interactable(self)
	
func on_body_exited(body):
	if not body is CharacterBody2D:
		return 
	player = null
	body.remove_interactable(self)

func on_interact():
	var d = []
	d.append({"name":"wood", "text":"Hi!"})
	global_data.dialog_data = d
	global_data.start_dialog()
	
