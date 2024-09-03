class_name CropManager
extends Node

var crop_data = {}
var soil_data = {}

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
	func _to_string() -> String:
		return "%s %s %s" %[name, stage, age]

class Soil:
	var name:String
	var crop:CropPlant
	func _init():
		name = ""
		crop = null

func get_crop(coord):
	return crop_data.get(coord)

func harvest_crop(coord):
	var crop = get_crop(coord)
	if not crop:
		return
	var info = DatabaseAgent.query_crop_data(crop.name)
	return crop.name if crop.stage == info.stage_num-1 else null # check if mature

func plant_crop(coord, name_) -> CropPlant:
	if not soil_data.has(coord) or soil_data[coord].crop:
		return null
	var crop = CropPlant.new(name_, 0, 0, 0)
	add_crop(coord, crop)
	Event.crop_changed.emit(coord, name_, crop_to_atlas(crop))
	return crop

func add_crop_by_atlas(coord, atlas):
	add_crop(coord, atlas_to_crop(atlas))

func add_crop(coord, crop:CropPlant):
	crop_data[coord] = crop
	soil_data[coord].crop = crop

func add_crop_by_attr(coord, crop_attr):
	var crop = CropPlant.new(crop_attr.name, crop_attr.quality, crop_attr.stage, crop_attr.age)
	crop_data[coord] = crop
	soil_data[coord].crop = crop
	Event.crop_changed.emit(coord, crop.name, crop_to_atlas(crop))

func add_soil(coord):
	soil_data[coord] = Soil.new()

func atlas_to_crop(atlas):
	var crop_name = DatabaseAgent.get_crop_by_id(atlas.y)
	if not crop_name:
		return null
	var quality = 0
	var stage = atlas.x
	var age = 0
	return CropPlant.new(crop_name, quality, stage, age)

func crop_to_atlas(crop):
	return Vector2i(crop.stage, DatabaseAgent.query_crop_data(crop.name).icon_row)

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
	Event.use_seed.connect(_on_use_seed)

func update_crops(time):
	for coord in crop_data:
		var crop = crop_data[coord]
		crop.age += 10
		var info = DatabaseAgent.query_crop_data(crop.name)
		if crop.stage < info.stage_num-1:
			var stage_duration = info.duration[crop.stage]
			if crop.age >= stage_duration:
				crop.stage += 1
				crop.age = 0
				Event.crop_changed.emit(coord, crop.name, crop_to_atlas(crop))

func _on_use_seed(crop_name):
	if plant_crop(GlobalData.player_coord, crop_name):
		Event.consume_equipment.emit()


func save_data():
	for coord in crop_data:
		var crop = crop_data[coord]
		var query = "INSERT OR REPLACE INTO field_plants (name,stage,age,quality,map,coord) VALUES ('%s',%s,%s, %s,%s,'%s') "\
			%[crop.name, crop.stage, crop.age, crop.quality, 0, '0-'+str(coord)]
		#print(query)
		DatabaseAgent.db.query(query)

func _load_field_plants():
	var res = DatabaseAgent.db.select_rows("field_plants", "", ["*"])
	for element in res:
		var coord = str_to_var('Vector2i'+element.coord.split('-')[1])
		print(coord)
		GlobalData.crop_manager.add_crop_by_attr(coord, element)
