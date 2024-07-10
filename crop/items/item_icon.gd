extends Sprite2D

@export var item_name:String:
	set(val):
		item_name=val
		update_sprite()

@onready var item_man = get_node("/root/GlobalData/ItemManager")

func update_sprite():
	if item_name == "":
		return
	var d = item_man.query_data(item_name)
	if not d:
		return
	texture = item_man.textures[d.texture]
	frame_coords = str_to_var(d.coord)
	return 
