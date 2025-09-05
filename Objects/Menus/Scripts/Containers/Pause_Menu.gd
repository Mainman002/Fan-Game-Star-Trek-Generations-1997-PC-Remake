extends Control

var _toggle:bool = false

@onready var tab_container: TabContainer = $MC/TabContainer


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("start_button"):
		_toggle = not _toggle
		match _toggle:
			false: hide_menu()
			true: show_menu()

	if _toggle and Input.is_action_just_pressed("B_button"):
		_toggle = false
		hide_menu()


func show_menu() -> void:
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	tab_container.current_tab = 0
	visible = true
	tab_container.get_child(0).get_node("VB").get_child(0).grab_focus()


func hide_menu() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	tab_container.current_tab = 0
	visible = false
