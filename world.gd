extends Node2D
@export var crop_tiles = {}
@export var carrot_scene : PackedScene
var player_coord = Vector2i(0,0)
const GROUND_LAYER = 0
const CROPS_LAYER = 1


var tile_set
var ground_source
var crops_source

var seed_atlas_coord = Vector2i(0,0)
var carrot_atlas_coord = Vector2i(1,0)
var crops_manager
var backpack_data

func _ready():
	tile_set = $Ground.tile_set
	ground_source = tile_set.get_source(0)
	crops_source = tile_set.get_source(2)
	init_crop_data()

func init_crop_data():
	var ground = $Ground
	var crop_cells = ground.get_used_cells(CROPS_LAYER)
	var data = {}
	for tile in crop_cells:
		data[tile] = get_tile_crops(tile)
	crops_manager = get_node("/root/GlobalDataManager/CropsManager")
	crops_manager.world = self
	crops_manager.crops_data = data
	backpack_data = get_node("/root/GlobalDataManager/BackpackData")


func respond(world_pos):
	player_coord = $Ground.local_to_map($Ground.to_local(world_pos))
	$GroundUI.player_pos = $Ground.map_to_local(player_coord)


func get_tile_data(coord, layer, source):
	var atlas_coord = $Ground.get_cell_atlas_coords(layer, coord)
	if atlas_coord == Vector2i(-1,-1):
		return ""
	var tile_data = source.get_tile_data(atlas_coord, 0)
	return tile_data
	
func get_tile_name(coord, layer, source):
	var tile_data = get_tile_data(coord, layer, source)
	var tile_name = tile_data.get_custom_data("name")
	return tile_name

func get_tile_ground(coord):
	return get_tile_name(coord, GROUND_LAYER, ground_source)

func get_tile_crops(coord):
	return get_tile_name(coord, CROPS_LAYER, crops_source)

# remove crop tile
func remove_crops(coord):
	$Ground.erase_cell(CROPS_LAYER, coord)

func set_crops(coord, type, override=false):	
	var crop_coord = Vector2i(-1, -1)
	# find crop
	if type == "carrot_seed":
		crop_coord = seed_atlas_coord
	elif type == "carrot":
		crop_coord = carrot_atlas_coord
	# apply crop
	if crop_coord != Vector2i(-1, -1):
		$Ground.set_cell(CROPS_LAYER, coord, 2, crop_coord)
		print ("add "+type)
	
func set_wet(coord, is_wet):
	if is_wet:
		$Ground.set_cell(GROUND_LAYER, coord, 0, Vector2(0,1))
	else:
		$Ground.set_cell(GROUND_LAYER, coord, 0, Vector2(0,0))

func handle_interaction():
	var crops_name = crops_manager.get_crops(player_coord)
	if crops_name == "carrot":
		crops_manager.remove_crops(player_coord)
		# drop_crop()
		backpack_data.add_item("carrot")
		return "carrot"

func drop_crop():
	var carrot = carrot_scene.instantiate()
	carrot.position = $GroundUI.player_pos 
	add_child(carrot)

func handle_use_item(item):
	var td = get_tile_data(player_coord, GROUND_LAYER, ground_source)
	var soil_name = td.get_custom_data("name")
	if soil_name == "soil":
		if item == "carrot_seed":
			crops_manager.set_crops(player_coord, "carrot_seed")
		elif item == "water":
			var is_wet = td.get_custom_data("wet")
			set_wet(player_coord, !is_wet)
	else:
		print("not soil")

