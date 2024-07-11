extends TileMap

var crop_source
var dirt_source
const dirt_layer = 0
const crop_layer = 1
var crop_data

func _ready():
	crop_source = tile_set.get_source(0)
	dirt_source = tile_set.get_source(1)
	init_crop_data()

func init_crop_data():
	crop_data = get_node("/root/GlobalData/CropData")
	crop_data.crop_tile_map = self
	
	var crop_cells = get_used_cells(crop_layer)
	for tile in crop_cells:
		var atlas = get_crop_atlas(tile)
		crop_data.add_crop_by_atlas(tile, atlas)


func get_tile_data(coord, layer, source):
	var atlas_coord = get_cell_atlas_coords(layer, coord)
	if atlas_coord == Vector2i(-1,-1):
		return null
	var tile_data = source.get_tile_data(atlas_coord, 0)
	return tile_data

func get_soil_data(coord):
	var td = get_tile_data(coord, dirt_layer, dirt_source)
	return td

func get_tile_name(coord, layer, source):
	var tile_data = get_tile_data(coord, layer, source)
	var tile_name = tile_data.get_custom_data("name")
	return tile_name

func get_crop_atlas(coord):
	var atlas_coord = get_cell_atlas_coords(crop_layer, coord)
	return atlas_coord

func set_crop(coord:Vector2i, crop_atlas:Vector2i):
	set_cell(crop_layer, coord, 0, crop_atlas)

func remove_crop(coord):
	erase_cell(crop_layer, coord)

func handle_interaction(coord):
	var crops_name = crop_data.get_crop(coord)
	if crops_name and crops_name != "":
		remove_crop(coord)
		print("pick up: "+crops_name)
		return crops_name

func set_wet(coord, is_wet):
	if is_wet:
		set_cell(dirt_layer, coord, 1, Vector2(0,1))
	else:
		set_cell(dirt_layer, coord, 1, Vector2(0,0))
