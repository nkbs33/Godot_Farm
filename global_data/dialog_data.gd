extends Node

var dialog_cache = {}
var db

func query_dialog(name, select_condition=""):
	if select_condition != "":
		select_condition = ("name = '%s'" % name) + " and " + ("trigger_condition = '%s'" % select_condition)
	else:
		select_condition = "name = '%s'" % name
	return DatabaseAgent.db.select_rows("dialog", select_condition, ["*"])

func query_dialog_by_id(id):
	db = DatabaseAgent.db
	var data = db.select_rows("dialog", "id = '%s'"%id, ["*"])[0]
	var ch_name = data.name
	cache_data( db.select_rows(("dialog"), "name = '%s'"%ch_name, ["*"]) )
	return data
	
func cache_data(data):
	for element in data:
		dialog_cache[element.id] = element

func next_id(character):
	return 1

func get_dialog(dialog_id):
	if dialog_cache.has(dialog_id):
		return dialog_cache[dialog_id]
	else:
		var dialog = query_dialog_by_id(dialog_id)
		return dialog

