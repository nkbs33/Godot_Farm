class_name CropTileMap
extends TileMap

const SOIL_LAYER = 0
const CROP_LAYER = 2
var crop_source:TileSetAtlasSource
var soil_source:TileSetAtlasSource

func _ready():
	crop_source = tile_set.get_source(0)
	soil_source = tile_set.get_source(1)
	init_crop_data()
	
	Event.crop_planted.connect(set_crop)
	Event.remove_crop.connect(remove_crop)

func init_crop_data():
	var crop_data:CropData = GlobalData.crop_data
	
	var soil_cells = get_used_cells(SOIL_LAYER)
	for tile in soil_cells:
		var soil_data = get_soil_data(tile)
		if soil_data.get_custom_data("plantable"):
			crop_data.add_soil(tile)
	
	var crop_cells = get_used_cells(CROP_LAYER)
	for tile in crop_cells:
		var atlas = get_cell_atlas_coords(CROP_LAYER, tile)
		crop_data.add_crop_by_atlas(tile, atlas)
	

func get_tile_data(coord, layer, source:TileSetAtlasSource):
	var atlas = get_cell_atlas_coords(layer, coord)
	if atlas == Vector2i(-1,-1):
		return null
	return source.get_tile_data(atlas, 0)

func get_soil_data(coord):
	var td = get_tile_data(coord, SOIL_LAYER, soil_source)
	return td

func get_tile_name(coord, layer, source):
	var tile_data = get_tile_data(coord, layer, source)
	var tile_name = tile_data.get_custom_data("name")
	return tile_name

func set_crop(coord:Vector2i, crop_name:String, crop_atlas:Vector2i):
	set_cell(CROP_LAYER, coord, 0, crop_atlas)

func remove_crop(coord):
	erase_cell(CROP_LAYER, coord)
