class_name CropData
extends Node

var crop_data = {}
var soil_data = {}

var crop_tile_map:CropTileMap
@onready var db_agent:DatabaseAgent = get_node("/root/GlobalData/DatabaseAgent")

class CropPlant:
	var name:String
	var quality:int
	var stage:int
	var age:int
	
	func _init(name_="", quality_=0, stage_=0, age_=0):
		name = name_
		quality = quality_
		stage = stage_
		age = age_

func harvest_crop(coord):
	if not crop_data.has(coord):
		return null
	var plant = crop_data[coord]
	var info = db_agent.query_crop_data(plant.name)
	return plant.name if plant.stage == info.stage_num else null # mature

func plant_crop(coord, name_):
	if crop_data.has(coord):
		return -1
	var dirt_td = crop_tile_map.get_soil_data(coord)
	if not dirt_td or not dirt_td.get_custom_data("plantable"):
		return -1
	var crop = CropPlant.new(name_, 0, 1, 0)
	crop_data[coord] = crop
	crop_tile_map.set_crop(coord, crop_to_atlas(crop))
	return 0

func add_crop_by_atlas(coord, atlas):
	crop_data[coord] = atlas_to_crop(atlas)

func atlas_to_crop(atlas):
	var crop_name = db_agent.get_crop_by_id(atlas.y)
	if not crop_name:
		return null
	var quality = 0
	var stage = atlas.x + 1
	var age = 0
	return CropPlant.new(crop_name, quality, stage, age)

func crop_to_atlas(crop):
	return Vector2i(0, db_agent.query_crop_data(crop.name).id)

func remove_crop(coord):
	if not crop_data.has(coord):
		print("error: coord not found in crop crop_data")
		return null
	var crops = crop_data[coord]
	crop_data.erase(coord)
	crop_tile_map.remove_crop(coord)
	return crops


func get_crop_atlas_coord(crop_name):
	var d = db_agent.query_crop_data(crop_name)
	if not d:
		return null
	return Vector2(0, d.id)
