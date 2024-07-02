extends CanvasLayer
signal set_player_controllable(enable)

var focus_element = null:
	set(value):
		set_player_controllable.emit(value==null)
		focus_element = value
			
@onready var backpack = $Backpack
@onready var dialog = $Dialogue

func _ready():
	initialize()

func initialize():
	$Backpack.hide()
	$Dialogue.hide()

func close_current():
	if focus_element != null:
		focus_element.toggle_visible(false)
		focus_element = null

func show_panel(panel):
	if focus_element:
		return
	panel.toggle_visible(true)
	focus_element = panel

func toggle_panel(panel):
	if focus_element == panel: # already visible
		close_current()
		return
	elif focus_element: # focusing others
		return
	focus_element = panel
	panel.toggle_visible(true)

func _on_player_toggle_panel(panel):
	if panel=="backpack":
		toggle_panel(backpack)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if focus_element == null:
			show_panel(dialog)
		focus_element.handle_action("ui_accept")
