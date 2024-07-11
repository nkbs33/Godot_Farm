extends Node

var crop_data = {}
var soil_data = {}

var crop_tile_map:CropTileMap
@onready var global_data = get_parent()

func make_crop(name_="", quality=0, stage=0, age=0):
	return {
		"name": name_, 
		"quality": quality, 
		"stage": stage, 
		"age": age,
		}

func get_crop_info(name_):
	var info = global_data.db_agent.query_crop_data(name_)
	return info

	
func harvest_crop(coord):
	if not crop_data.has(coord):
		return null
	var data = crop_data[coord]
	var info = get_crop_info(data.name)
	if data["stage"] == info["stage_num"]: # mature
		return data.name
	else:
		return null


func plant_crop(coord, name_):
	if crop_data.has(coord):
		return -1
	var dirt_td = crop_tile_map.get_soil_data(coord)
	if not dirt_td or not dirt_td.get_custom_data("plantable"):
		return -1
	crop_data[coord] = make_crop(name_, 0, 1, 0)
	var atlas = Vector2i(0, get_crop_info(name_).id)
	crop_tile_map.set_crop(coord, atlas)
	return 0


func add_crop_by_atlas(coord, atlas):
	var crop_name = global_data.db_agent.get_crop_by_id(atlas.y)
	if not crop_name:
		return
	var crop = make_crop(crop_name, 0, atlas.x+1, 0)
	crop_data[coord] = crop

func remove_crop(coord):
	if not crop_data.has(coord):
		print("error: coord not found in crop crop_data")
		return null
	var crops = crop_data[coord]
	crop_data.erase(coord)
	crop_tile_map.remove_crop(coord)
	return crops


func get_crop_atlas_coord(crop_name):
	var d = global_data.db_agent.query_crop_data(crop_name)
	if not d:
		return null
	return Vector2(0, d.id)
