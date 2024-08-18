extends Panel
signal display_finished

@export var smooth_display_enabled:bool = true
@export var text_speed:float = 5.0
@export var comma_pause = 0.3
@export var period_pause = 0.5
var pause_timer = 0.0

var is_playing:bool = false
var play_timer:float

func set_data(name, text):
	$Name.text = "[center]"+name+"[/center]"
	$Text.text = text 


func _process(delta):
	if not is_playing:
		return
	if pause_timer > 0:
		pause_timer -= delta
		return
	play_timer += delta 
	while play_timer > 0.05/text_speed:
		step_dialog_display()
		play_timer -= 0.05/text_speed

func start_display():
	hide_options()
	if not smooth_display_enabled:
		return
	$Text.visible_characters = 0
	is_playing = true
	play_timer = 0
	

func step_dialog_display():
	$Text.visible_characters += 1
	if $Text.visible_characters >= $Text.text.length():
		is_playing = false
		display_finished.emit()
	else:
		var char = $Text.text[$Text.visible_characters-1]
		if char == '，':
			pause_timer = comma_pause
		elif char == '。' or char == '？':
			pause_timer = period_pause

func hide_options():
	for c in %OptionGrid.get_children():
		c.hide()
