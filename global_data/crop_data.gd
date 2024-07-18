class_name CropData
extends Node

var crop_data = {}
var soil_data = {}


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

class Soil:
	var name:String
	var crop:CropPlant
	func _init():
		name = ""
		crop = null

func harvest_crop(coord):
	if not crop_data.has(coord):
		return null
	var crop = crop_data[coord]
	var info = db_agent.query_crop_data(crop.name)
	return crop.name if crop.stage == info.stage_num-1 else null # mature

func plant_crop(coord, name_):
	if not soil_data.has(coord) or soil_data[coord].crop:
		return -1
	var crop = CropPlant.new(name_, 0, 0, 0)
	add_crop(coord, crop)
	Event.plant_crop.emit(coord, crop_to_atlas(crop))
	return 0

func add_crop_by_atlas(coord, atlas):
	add_crop(coord, atlas_to_crop(atlas))

func add_crop(coord, crop:CropPlant):
	crop_data[coord] = crop
	soil_data[coord].crop = crop

func add_soil(coord):
	soil_data[coord] = Soil.new()

func atlas_to_crop(atlas):
	var crop_name = db_agent.get_crop_by_id(atlas.y)
	if not crop_name:
		return null
	var quality = 0
	var stage = atlas.x
	var age = 0
	return CropPlant.new(crop_name, quality, stage, age)

func crop_to_atlas(crop):
	return Vector2i(crop.stage, db_agent.query_crop_data(crop.name).id)

func remove_crop(coord):
	if not crop_data.has(coord):
		print("error: coord not found in crop crop_data")
		return null
	var crops = crop_data[coord]
	crop_data.erase(coord)
	soil_data[coord].crop = null
	Event.remove_crop.emit(coord)
	return crops

func _ready():
	Event.update_time.connect(update_crops)

func update_crops(time):
	for coord in crop_data:
		var crop = crop_data[coord]
		crop.age += 10
		var info = db_agent.query_crop_data(crop.name)
		if crop.stage < info.stage_num-1:
			var stage_duration = info.duration[crop.stage]
			if crop.age >= stage_duration:
				crop.stage += 1
				crop.age = 0
				Event.plant_crop.emit(coord, crop_to_atlas(crop))
			
