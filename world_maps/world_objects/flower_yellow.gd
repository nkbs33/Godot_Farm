extends Sprite2D

@export var npc_name = "yellow flower"
var dialog_data = []
var first_met = true

func _ready():
	$InteractiveRegion.interact_start.connect(on_interact)

func on_interact():
	if first_met:
		dialog_data = GlobalData.db_agent.query_dialog(npc_name, "context = 'first met'")
		first_met = false
	else:
		dialog_data = GlobalData.db_agent.query_dialog(npc_name, "context=''")
	Event.start_dialog.emit(dialog_data)
