extends CanvasLayer
signal set_player_input(enable)

var focus:String = ""
var focus_element = null:
	set(value):
		set_player_input.emit(value==null)
		focus_element = value
			
@onready var backpack = $Backpack
@onready var dialog = $Dialogue

func _ready():
	$Backpack.hide()
	$Dialogue.hide()
		
func close_current():
	if focus_element != null:
		focus_element.hide()
		focus_element = null
	focus = ""

func toggle_backpack():
	if focus == "backpack":
		close_current()
		return
	elif focus != "":
		return
	focus = "backpack"
	focus_element = backpack
	focus_element.show()

func _on_player_toggle_panel(panel):
	if panel=="backpack":
		toggle_backpack()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if focus == "":
			show_dialog()
		if focus_element != null:
			focus_element.handle_action("ui_accept")

func show_dialog():
	dialog.show()
	dialog.dialog_index = -1
	focus = "dialogue"
	focus_element = dialog
