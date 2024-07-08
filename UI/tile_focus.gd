extends Panel

func _ready():
	get_node("/root/GlobalData").tile_focus = self
