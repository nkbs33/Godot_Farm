class_name LineInput
extends Control


func make_input_dialog(prompt="prompt", place_holder="place_holder", callback=null):
	get_node("panel/prompt").text = prompt
	get_node("panel/field").text = place_holder
	var confirm:Signal = get_node("panel/confirm").pressed
	for con in confirm.get_connections():
		confirm.disconnect(con.callable)
	confirm.connect(_on_confirm_click)
	if callback:
		get_node("panel/confirm").pressed.connect(callback)
	
func _on_confirm_click():
	hide()

func value():
	return get_node("panel/field").text
