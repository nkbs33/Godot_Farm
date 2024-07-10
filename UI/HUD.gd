extends CanvasLayer

var focus = null:
	set(value):
		focus = value
		if focus:
			isBackground = false
		else:
			update_player_lock()

var isBackground:bool:
	set(val):
		isBackground = val
		update_player_lock()
		if not focus:
			return
		if val:
			focus.modulate = Color(1,1,1,0.75)
		else:
			focus.modulate = Color(1,1,1,1)

@onready var backpack = $Backpack
@onready var dialog = $Dialogue
var global_data
var viewport_pos

func _ready():
	initialize()

func initialize():
	#Backpack.toggle_visible(false)
	$Dialogue.hide()
	global_data = get_node("/root/GlobalData")
	global_data.hud = self

func update_player_lock():
	if global_data and global_data.player:
		global_data.player.enable_control(focus==null or isBackground)

# show only
func show_panel(panel):
	if focus:
		return
	panel.toggle_visible(true)

# switch show/hide automatically
func toggle_panel(panel):
	if focus == panel: # already visible
		focus.toggle_visible(false)
		return
	elif focus: # focusing others
		return
	panel.toggle_visible(true)

func toggle_panel_by_name(panel_name):
	if panel_name == "backpack":
		toggle_panel(backpack)

func _on_player_toggle_panel(panel):
	if panel=="backpack":
		toggle_panel(backpack)

func _input(event):
	if not focus or not $MoveTimer.is_stopped():
		return
	if focus == dialog:
		return
	if event.is_action_pressed("switch_focus"):
		isBackground = not isBackground

func _process(delta):
	if not focus or not $MoveTimer.is_stopped():
		return
	if isBackground:
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
	if focus.move_by_vec(move_vec):
		$MoveTimer.start()
