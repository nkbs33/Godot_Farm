extends Sprite2D

func update_sprite(item_name):
	if item_name == "":
		texture = null
		return
	var db_agent = GlobalData.db_agent
	var d = db_agent.query_item_info(item_name)
	if not d:
		return
	texture = db_agent.textures[d.texture]
	frame_coords = str_to_var(d.coord)
	return 
