extends Node

const db_path = "res://global_data/database/"

var db:SQLite
var item_db_ = {}
var crop_db = {}
var textures = {}

var id_to_crop = {}

func _ready():
	db = SQLite.new()
	db.path = "res://assets/database/data.db"
	db.open_db()
	
	Event.database_opened.emit()
	
	_load_item_db("items")
	_load_crop_db("crop")
	_load_inventory()
	load_tex()

func load_tex():
	var tex = load("res://crop/assets/farming-Plants-items.png")
	textures["crop_item"] = tex;

func _load_item_db(table):
	var res = db.select_rows(table,"", ["*"])
	for element in res:
		item_db_[element.name] = element
		element.coord = "Vector2i"+element.coord

func _load_crop_db(table):
	var res = db.select_rows(table,"", ["*"])
	for element in res:
		crop_db[element.name] = element
		id_to_crop[(int)(element.icon_row)] = element.name
		element.duration = str_to_var("["+element.duration+"]")

func _load_inventory():
	var res = db.select_rows("inventory", "", ["*"])
	for element in res:
		if element.location == 'backpack':
			GlobalData.backpack.set_item(element.item_name, element.num, element.id)
	GlobalData.backpack.bag_item_change.connect(_on_bag_item_change)

func _on_bag_item_change(item:BackpackData.Item):
	var query = "INSERT OR REPLACE INTO inventory (item_name,location,num,id) VALUES ('%s','%s',%s,%s) "\
		%[item.name, 'backpack', item.num, item.index]
	db.query(query)




func query_item_info(item_name):
	if item_db_.has(item_name):
		return item_db_[item_name]
	else:
		return null

func query_crop_data(crop_name):
	if crop_db.has(crop_name):
		return crop_db[crop_name]
	else:
		return null

func get_crop_by_id(id):
	if not id_to_crop.has(id):
		print("null", id)
		return null
	return id_to_crop[id]

func query_raw(table, sql):
	return db.select_rows(table, sql, ["*"]);
