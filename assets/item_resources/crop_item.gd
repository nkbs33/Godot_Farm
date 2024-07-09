extends Sprite2D

@export var path:String
@export var item_name:String:
	set(val):
		item_name=val
		update_sprite()
		
var dict = {}

func _ready():
	var f = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(f.get_as_text())
	#print(data)
	for i in range(data.size()):
		#print(data[i])
		dict[data[i].name] = i
	update_sprite()

func update_sprite():
	if item_name == "":
		return
	if not dict.has(item_name):
		print("error: invalid item name "+item_name)
		return 
	else:
		frame_coords = Vector2(1, dict[item_name])

func _process(delta):
	pass
