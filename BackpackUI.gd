extends ColorRect


func _ready():
	hide()
	var backpack = get_node("/root/GlobalDataManager/BackpackData")
	backpack.item_num_change.connect(_on_backpack_item_num_change)

func _on_backpack_item_num_change(index, num):
	$Slots.get_node("Slot_"+str(index)).num = num

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
