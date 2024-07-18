class_name DatabaseAgent
extends Node

const db_path = "res://global_data/database/"
const item_db_path = db_path + "item_db.json"
const plant_db_path = db_path + "plant_db.json"

var item_db = {}
var crop_db = {}
var textures = {}

var id_to_crop = {}

func _ready():
	load_tex()
	load_item_db()
	load_crop_db()

func load_tex():
	var tex = load("res://crop/assets/farming-Plants-items.png")
	textures["crop_item"] = tex;

func load_item_db():
	var f = FileAccess.open(item_db_path, FileAccess.READ)
	var data_raw = JSON.parse_string(f.get_as_text())
	for element in data_raw:
		item_db[element.name] = element

func load_crop_db():
	var f = FileAccess.open(plant_db_path, FileAccess.READ)
	var data_raw = JSON.parse_string(f.get_as_text())
	for element in data_raw:
		crop_db[element.name] = element
		id_to_crop[(int)(element.id)] = element.name


func query_item_data(item_name):
	if item_db.has(item_name):
		return item_db[item_name]
	else:
		return null

func query_crop_data(crop_name):
	if crop_db.has(crop_name):
		return crop_db[crop_name]
	else:
		return null

func get_crop_by_id(id):
	if not id_to_crop.has(id):
		return null
	return id_to_crop[id]
