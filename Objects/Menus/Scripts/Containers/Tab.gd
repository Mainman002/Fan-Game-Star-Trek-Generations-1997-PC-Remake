extends Control

@export var first_focus:Node


func select_focused() -> void:
	if not first_focus:
		return

	if is_instance_valid(first_focus):
		first_focus.grab_focus()
