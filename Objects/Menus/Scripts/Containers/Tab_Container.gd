extends TabContainer

var max_tabs:int = 0

@onready var pause_menu: Control = $"../.."


func _ready() -> void:
	max_tabs = get_tab_count()-1


func _input(_event: InputEvent) -> void:
	if not pause_menu.visible:
		return

	if Input.is_action_just_pressed("tab_left"):
		if current_tab > 0:
			current_tab -= 1
		else: current_tab = max_tabs
	elif Input.is_action_just_pressed("tab_right"):
		if current_tab < max_tabs:
			current_tab += 1
		else: current_tab = 0

	#if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("L_joy_right"):
		#if current_tab > 0:
			#current_tab -= 1
		#else: current_tab = max_tabs
	#elif Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("L_joy_left"):
		#if current_tab < max_tabs:
			#current_tab += 1
		#else: current_tab = 0


func _on_tab_changed( _tab:int ) -> void:
	if not pause_menu.visible:
		return

	await get_tree().process_frame
	get_child(_tab).select_focused()
	#if get_child(_tab).get_node("VB").get_child_count() > 1:
		#get_child(_tab).get_node("VB").get_child(0).grab_focus()
