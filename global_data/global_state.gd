extends Node

var global_vars = {}
var character_dict = {}

func get_character_state_dict(character):
	if not character_dict.has(character):
		character_dict[character] = {}
	return character_dict[character]

func set_character_state(character:String, key:String, value):
	var state = get_character_state_dict(character)
	state[key]=value

func get_character_state(character:String, key):
	var state = get_character_state_dict(character)
	if not state.has(key):
		return null
	return state[key]

func _enter_tree():
	Event.database_opened.connect(load_data)

func load_data():
	var res = DatabaseAgent.query_raw("npc_relationship","")
	for d in res:
		set_character_state(d.name, "chat num", d["chat_num"])
	
	var d = DatabaseAgent.query_raw("player", "id = 1")[0]
	global_vars["player_name"] = d.name
	global_vars["farm_skill"] = d.farm_skill	
	
func save_data():
	GlobalData.crop_manager.save_data()
	print("save data")
