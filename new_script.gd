@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var scene = get_scene()
	# print("you are editing: %s" % scene.name)
	var d = {}
	var ground = scene.find_child("ground")
	var crop_cells = ground.get_used_cells(1)
	print("crop tile num: %s" % crop_cells.size())
	var tile_set = ground.tile_set
	var crop_source = tile_set.get_source(2)
	
	for tile in crop_cells:
		var source_id = ground.get_cell_source_id(1, tile)
		var source = tile_set.get_source(source_id)
		var atlas_cd = ground.get_cell_atlas_coords(1, tile)
		var td = source.get_tile_data(atlas_cd, 0)
		var data = td.get_custom_data("name")
		d[tile] = data
	scene.crop_tiles = d
