extends Node


# all the crops data
# type
# growing days
# level
var crops_data = {}

# all the tile data
# dry/wet
# nutrition level
var tile_data = {}
var world

func get_crops(coord):
	if not crops_data.has(coord):
		return null
	return crops_data[coord]

func add_crops(type, coord):
	if not crops_data.has(coord):
		print("error: crop already exists")
		return
	crops_data[coord] = type

func remove_crops(coord):
	if not crops_data.has(coord):
		print("error: crop does not exist")
		return null
	var crops = crops_data[coord]
	crops_data.erase(coord)
	world.remove_crops(coord)
	return crops

func set_crops(coord, type, override=false):
	if !override and crops_data.has(coord):
		return
	crops_data[coord] = type
	world.set_crops(coord, type)
