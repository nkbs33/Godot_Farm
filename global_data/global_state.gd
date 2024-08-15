class_name GlobalState
extends Node

class State:
	var character:String
	var key:String
	var value:String

var StateDict = {}
var character_dict = {}

func get_character_state_dict(character):
	if not character_dict.has(character):
		character_dict[character] = {}
	return character_dict[character]

func set_character_state(character:String, key:String, value:String):
	var state = get_character_state_dict(character)
	state[key]=value

func get_character_state(character:String, key:String):
	var state = get_character_state_dict(character)
	if not state.has(key):
		return null
	return state[key]
