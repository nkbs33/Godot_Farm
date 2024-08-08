class_name BackpackData
extends Node

signal bag_item_change(item)
signal money_change(num)

@export var items = []
var num_empty = 0
const num_slots = 27

var equipment_idx:int = -1
var equipment:Node
var money:int:
	set(v):
		money=v
		money_change.emit(money)

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
	var value:int
	
	func _init(name_="", index_=0, num_=0, type_=ItemType.Item, value_=0):
		name = name_
		num = num_
		index = index_
		type = type_
		value = value_
		

func _ready():
	items.resize(num_slots)
	num_empty = num_slots
	for i in range(num_slots):
		items[i] = Item.new("", i)
	Event.pickup_item.connect(_on_pickup_item)
	Event.consume_equipment.connect(_on_consume_equipment)

func get_empty_slot():
	for i in range(num_slots):
		if items[i].num == 0:
			return i
	return -1

func find_item(name_):
	if name_ == "":
		return -1
	for i in range(num_slots):
		if items[i] and items[i].name == name_:
			return i
	return -1

func add_item(name_):
	var idx = find_item(name_)
	if idx >= 0:
		items[idx].num += 1
		bag_item_change.emit(items[idx])
		return idx
	idx = get_empty_slot()
	if idx >= 0:
		var item_info = GlobalData.db_agent.query_item_info(name_)
		items[idx].name = name_
		items[idx].num = 1
		items[idx].value = item_info.value
		match item_info.type:
			"item": items[idx].type = ItemType.Item
			"equipment": items[idx].type = ItemType.Equipment			
		bag_item_change.emit(items[idx])
	return idx

func change_item_num(id, change):
	items[id].num += change
	bag_item_change.emit(items[id])
	if id == equipment_idx:
		Event.equipment_num_change.emit(items[id].num)

func set_item_num(id, num_):
	items[id].num = num_
	bag_item_change.emit(items[id])
	if id == equipment_idx:
		Event.equipment_num_change.emit(num_)

func _on_pickup_item(item_name):
	add_item(item_name)

func use(idx):
	match items[idx].type:
		ItemType.Item:
			pass
		ItemType.Equipment:
			if equipment_idx == idx:
				unequip_from_backpack(idx)
			else:
				equip_from_backpack(idx)
	
func get_item_menu_entries(idx):
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
	return entries

func equip_from_backpack(idx):
	equipment_idx = idx
	var equipment_name = items[idx].name
	var d = GlobalData.db_agent.query_item_info(equipment_name)
	items[idx].consume = d.consume
	equipment = load("res://"+d.nodepath).instantiate()
	if d.subtype == "seed":
		equipment.item_name = d.name
		var crop_name = d.name.substr(0, d.name.rfind("_"))
		equipment.crop_name = crop_name
	Event.player_equip.emit(equipment)
	Event.equipment_num_change.emit(items[idx].num)

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
