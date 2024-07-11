extends Sprite2D

@export var item_name:String:
	set(val):
		item_name=val
		update_sprite()
		
var db_agent

func _ready():
	update_sprite()

func get_item_data():
	if not db_agent:
		db_agent = get_node("/root/GlobalData").db_agent
	return db_agent.query_item_data(item_name)

func update_sprite():
	if not is_node_ready():
		return
	if item_name == "":
		texture = null
		return
	var d = get_item_data()
	if not d:
		return
	texture = db_agent.textures[d.texture]
	frame_coords = str_to_var(d.coord)
	return 
