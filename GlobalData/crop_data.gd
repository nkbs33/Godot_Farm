extends Node

# crops data
# type, growing days, quality level
var data = {}
# tile data
# dry/wet, nutrition level
var tile_data = {}
var crop_tile_map

func get_crop(coord):
	if not data.has(coord):
		return null
	return data[coord]

func add_crops(type, coord):
	if not data.has(coord):
		print("error: crop already exists")
		return
	data[coord] = type

func remove_crop(coord):
	if not data.has(coord):
		print("error: coord not found in crop data")
		return null
	var crops = data[coord]
	data.erase(coord)
	crop_tile_map.remove_crop(coord)
	return crops

func set_crop(coord, crop_name, override=false):
	if not override and data.has(coord):
		return
	data[coord] = crop_name
	crop_tile_map.set_crop(coord, crop_name)
