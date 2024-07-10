extends Node

const db_path = "res://global_data/database/"
const item_db_path = db_path + "item_db.json"
const plant_db_path = db_path + "plant_db.json"
var data = {}
var textures = {}

func _ready():
	load_tex()
	load_database()

func load_tex():
	var tex = load("res://crop/assets/farming-Plants-items.png")
	textures["crop_item"] = tex;

func load_database():
	var f = FileAccess.open(item_db_path, FileAccess.READ)
	var data_raw = JSON.parse_string(f.get_as_text())
	for element in data_raw:
		data[element.name] = element
		
	f = FileAccess.open(plant_db_path, FileAccess.READ)
	data_raw = JSON.parse_string(f.get_as_text())
	print(data_raw)

func query_icon(item_name):
	if data.has(item_name):
		return data[item_name]
	else:
		return null
