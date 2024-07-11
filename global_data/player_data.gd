extends Node

var equipment_name:String
var equipment

func equip(val:String):
	equipment_name = val

func use_equipment():
	if not equipment:
		return 
	equipment.work()

