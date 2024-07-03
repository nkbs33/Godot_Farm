extends CanvasLayer
signal set_player_controllable(enable)

var focus_element = null:
	set(value):
		set_player_controllable.emit(value==null)
		focus_element = value
			
@onready var backpack = $Backpack
@onready var dialog = $Dialogue
var global_data

func _ready():
	initialize()

func initialize():
	$Backpack.hide()
	$Dialogue.hide()
	global_data = get_node("/root/GlobalData")
	global_data.hud = self

func close_current():
	focus_element = null

func show_panel(panel):
	if focus_element:
		return
	panel.toggle_visible(true)
	focus_element = panel

func toggle_panel(panel):
	if focus_element == panel: # already visible
		focus_element.toggle_visible(false)
		return
	elif focus_element: # focusing others
		return
	focus_element = panel
	panel.toggle_visible(true)

func toggle_panel_by_name(panel_name):
	if panel_name == "dialog":
		toggle_panel(dialog)
	elif panel_name == "backpack":
		toggle_panel(backpack)

func _on_player_toggle_panel(panel):
	if panel=="backpack":
		toggle_panel(backpack)

func _input(event):
	if focus_element == null:
		return
	if event.is_action_pressed("ui_accept"):
		focus_element.handle_action("ui_accept")

func _process(delta):
	if not focus_element or not $MoveTimer.is_stopped():
		return
	var move_vec = Vector2(0,0) 
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if move_vec == Vector2.ZERO:
		return
	if focus_element.move_by_vec(move_vec):
		$MoveTimer.start()
