extends Sprite2D

@export var item_name:String:
	set(val):
		item_name=val
		update_sprite()
		
@onready var db_agent:DatabaseAgent = GlobalData.db_agent

func _ready():
	update_sprite()

func update_sprite():
	if not is_node_ready():
		return
	if item_name == "":
		texture = null
		return
	var d = db_agent.query_item_info(item_name)
	if not d:
		return
	texture = db_agent.textures[d.texture]
	frame_coords = str_to_var(d.coord)
	return 
