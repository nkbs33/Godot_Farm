extends Sprite2D

func update_sprite(item_name):
	if item_name == "":
		texture = null
		return
	var d = DatabaseAgent.query_item_info(item_name)
	if not d:
		return
	texture = DatabaseAgent.textures[d.texture]
	frame_coords = str_to_var(d.coord)
	return 
