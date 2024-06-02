@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type("MyButton", "Button", preload("my_button.gd"), preload("res://resources/icon.svg"))


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("MyButton")
