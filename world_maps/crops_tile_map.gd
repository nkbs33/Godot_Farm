extends TileMap

var crops_source
var dirt_source
const dirt_layer = 0
const crops_layer = 1
var crop_data

func _ready():
	var tile_set = get_tileset()
	crops_source = tile_set.get_source(0)
	dirt_source = tile_set.get_source(1)
	init_crop_data()

func init_crop_data():
	var crop_cells = get_crop_cells()
	var data = {}
	for tile in crop_cells:
		data[tile] = get_crop_name(tile)
	crop_data = get_node("/root/GlobalData/CropData")
	crop_data.data = data
	crop_data.crop_tile_map = self

func _process(delta):
	pass

func get_tile_data(coord, layer, source):
	var atlas_coord = get_cell_atlas_coords(layer, coord)
	if atlas_coord == Vector2i(-1,-1):
		return null
	var tile_data = source.get_tile_data(atlas_coord, 0)
	return tile_data

func get_tile_name(coord, layer, source):
	var tile_data = get_tile_data(coord, layer, source)
	var tile_name = tile_data.get_custom_data("name")
	return tile_name

func get_crop_name(coord):
	return get_tile_name(coord, crops_layer, crops_source)

func get_crop_cells():
	return get_used_cells(crops_layer)

func set_crop(coord, crop_name):
	var atlas_coord = Vector2(3,7)
	set_cell(crops_layer, coord, 0, atlas_coord)

func remove_crop(coord):
	erase_cell(crops_layer, coord)

func handle_use_item(coord, item):
	var td = get_tile_data(coord, dirt_layer, dirt_source)
	var soil_name = td.get_custom_data("name")
	if soil_name == "soil":
		if item == "carrot_seed":
			set_crop(coord, Vector2(3,7))
		elif item == "water":
			set_wet(coord, true)
	else:
		print("not soil")

func handle_interaction(coord):
	var crops_name = crop_data.get_crops(coord)
	if crops_name and crops_name != "":
		remove_crop(coord)
		print("pick up: "+crops_name)
		return crops_name

func set_wet(coord, is_wet):
	if is_wet:
		set_cell(dirt_layer, coord, 1, Vector2(0,1))
	else:
		set_cell(dirt_layer, coord, 1, Vector2(0,0))
