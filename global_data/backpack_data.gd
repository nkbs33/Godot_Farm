extends Node

@export var items = []
var num_empty = 0
const num_slots = 27
var equipment_idx:int = -1

enum ItemType {
	Item,
	Equipment
}

class Item:
	var name:String
	var index:int
	var num:int
	var type:ItemType
	var consume:bool
	
	func _init(name_="", index_=0, num_=0, type_=ItemType.Item):
		name = name_
		num = num_
		index = index_
		type = type_
		

func _ready():
	items.resize(num_slots)
	num_empty = num_slots
	for i in range(num_slots):
		items[i] = Item.new("", i, 0, ItemType.Item)
	Event.pickup_item.connect(_on_pickup_item)
	Event.pre_item_menu_show.connect(get_item_menu_entries)
	Event.equip_backpack_item.connect(equip_from_backpack)
	Event.unequip_backpack_item.connect(unequip_from_backpack)
	Event.consume_equipment.connect(_on_consume_equipment)

func get_empty_slot():
	for i in range(num_slots):
		if items[i].num == 0:
			return i
	return -1

func find_item(name_):
	for i in range(num_slots):
		if items[i] and items[i].name == name_:
			return i
	return -1

func add_item(name_):
	var idx = find_item(name_)
	if idx >= 0:
		items[idx].num += 1
		Event.bag_item_change.emit(items[idx])
		return idx
	idx = get_empty_slot()
	if idx >= 0:
		var item_info = GlobalData.db_agent.query_item_info(name_)
		items[idx].name = name_
		items[idx].num = 1
		match item_info.type:
			"item": items[idx].type = ItemType.Item
			"equipment": items[idx].type = ItemType.Equipment			
		Event.bag_item_change.emit(items[idx])
	return idx

func change_item_num(id, change):
	items[id].num += change
	Event.bag_item_change.emit(items[id])

func set_item_num(id, num_):
	items[id].num = num_
	Event.bag_item_change.emit(items[id])

func _on_pickup_item(item_name):
	add_item(item_name)

func get_item_menu_entries(idx, cb):
	var entries = []
	match items[idx].type:
		ItemType.Item:
			entries.append_array(["use"])
		ItemType.Equipment:
			if idx != equipment_idx:
				entries.append_array(["equip"])
			else:
				entries.append_array(["unequip"])
	entries.append("cancel")
	cb.call(entries) 

func equip_from_backpack(idx):
	equipment_idx = idx
	var equipment_name = items[idx].name
	var d = GlobalData.db_agent.query_item_info(equipment_name)
	items[idx].consume = d.consume
	if not d.has("eq_path"):
		return
	var eqnode = load("res://"+d.eq_path).instantiate()
	if d.subtype == "seed":
		eqnode.item_name = d.name
		eqnode.crop_name = d.crop
	Event.player_equip.emit(eqnode)

func unequip_from_backpack(idx):
	equipment_idx = -1
	Event.player_unequip.emit()

func _on_consume_equipment():
	if equipment_idx == -1:
		return
	if not items[equipment_idx].consume:
		return
	change_item_num(equipment_idx, -1)
	if items[equipment_idx].num == 0:
		equipment_idx = -1
		Event.player_unequip.emit()
