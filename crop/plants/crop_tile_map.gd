class_name CropTileMap
extends Node2D

const SOIL_LAYER = 0
const CROP_LAYER = 2
var crop_source:TileSetAtlasSource
var soil_source:TileSetAtlasSource
var tile_set
var crop_manager

func _ready():
	tile_set = $crop.tile_set
	crop_source = tile_set.get_source(0)
	soil_source = tile_set.get_source(1)
	init_crop_data()
	
	Event.crop_changed.connect(set_crop)
	Event.remove_crop.connect(remove_crop)
	
	crop_manager._load_field_plants()

func init_crop_data():
	crop_manager = GlobalData.crop_manager
	
	var soil_cells = $soil.get_used_cells()
	for tile in soil_cells:
		var soil_data = get_soil_data(tile)
		if soil_data.get_custom_data("plantable"):
			crop_manager.add_soil(tile)
	
	var crop_cells = $crop.get_used_cells()
	for tile in crop_cells:
		var atlas = $crop.get_cell_atlas_coords(tile)
		crop_manager.add_crop_by_atlas(tile, atlas)
	
func get_tile_data(coord, layer, source:TileSetAtlasSource):
	var atlas = layer.get_cell_atlas_coords(coord)
	if atlas == Vector2i(-1,-1):
		return null
	return source.get_tile_data(atlas, 0)

func get_soil_data(coord):
	var td = get_tile_data(coord, $soil, soil_source)
	return td

func get_tile_name(coord, layer, source):
	var tile_data = get_tile_data(coord, layer, source)
	var tile_name = tile_data.get_custom_data("name")
	return tile_name

func set_crop(coord:Vector2i, crop_name:String, crop_atlas:Vector2i):
	$crop.set_cell(coord, 0, crop_atlas)

func remove_crop(coord):
	$crop.erase_cell(coord)
