extends Control

#var fullscreen:bool = false

const scene_list := {
	## Menus
	"blank": preload("res://Scenes/Blank.tscn"),

	## Scenes
	"day": preload("res://Scenes/Levels/Dungeon_Test_Day.tscn"),
	"night": preload("res://Scenes/Levels/Dungeon_Test_Night.tscn"),
}

var next_scene: String = ""
var scene_state:int = 0
var changing_scenes:bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var scenes: Node = $Scenes
#@onready var pause_menu: Control = $Menus/Pause_Menu


func _ready() -> void:
	#if fullscreen: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	animation_player.animation_finished.connect(_on_animation_finished)
	_change_scene("blank")


func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("start_button"):
		#pause_menu.show_menu()
		#Input.MOUSE_MODE_VISIBLE
		#pause_menu.visible = true
	#if !mouseFree: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#else: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if next_scene == "Quit":
		return

	if event is InputEventScreenTouch || event is InputEventKey || Input.is_action_just_pressed("A_button") || Input.is_action_just_pressed("B_button") || Input.is_action_just_pressed("X_button") || Input.is_action_just_pressed("Y_button"):
		if changing_scenes:
			changing_scenes = false
			_remove_scene()
			await get_tree().process_frame
			animation_player.play("Fade_In")


#func window_set_rect_changed_callback(_callback: Callable, _window_id: int = 0):
	#print( _callback )


#func _process(_delta: float) -> void:
	#if Window.is_res:
		#visibility_changed()


#func _notification( what ):
	#if what == NOTIFICATION_WM_SIZE_CHANGED:
		#visibility_changed()


#func visibility_changed() -> void:
	#get_viewport().size_changed
	#SettingsManager._refresh_settings()
	#print( "Changed" )


func _skip_transition(scene: String) -> void:
	if not (animation_player.is_playing() and animation_player.current_animation == "Fade_In"):
		_change_scene(scene)


func _change_scene(scene: String) -> void:
	var _scene:String = scene.to_lower()

	if _scene == "quit":
		changing_scenes = false
		next_scene = "Quit"
		animation_player.play("Fade_Out")
	else:
		changing_scenes = true
		if next_scene != _scene:
			next_scene = _scene
			animation_player.play("Fade_Out")


func _on_animation_finished(anim_name: String) -> void:
	#print( anim_name )
	#match anim_name:
		#"Fade_Out":
			#if next_scene == "Quit":
				#changing_scenes = false
				#get_tree().quit()
			#else:
				#changing_scenes = true
				#_remove_scene()
				#animation_player.play("Fade_In")

	if anim_name == "Fade_Out":
		_remove_scene()
		if next_scene == "Quit":
			get_tree().quit()
		else:
			_add_scene()
			animation_player.play("Fade_In")
		changing_scenes = false


func _add_scene() -> void:
	if next_scene in scene_list:
		var new_scene = scene_list[next_scene].instantiate()
		scenes.add_child(new_scene)


func _remove_scene() -> void:
	SettingsManager._free_ui_items()

	for child in scenes.get_children():
		child.queue_free()
