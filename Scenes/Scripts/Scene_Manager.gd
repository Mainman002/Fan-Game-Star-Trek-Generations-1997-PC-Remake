@tool
extends Control

#var fullscreen:bool = false

@export var refresh_scenes:bool:
	set(value):
		if value:
			if scene_entries_dir:
				_refresh_scenes()
				print("Scene list refreshed from folder:\n", scene_entries_dir)
			else:
				printerr('Scene list could not refresh, "Scene Entries Dir" folder not selected')
			refresh_scenes = false
			notify_property_list_changed()

<<<<<<< HEAD
	## Scenes
	"day": preload("res://Scenes/Levels/Dungeon_Test_Day.tscn"),
	"night": preload("res://Scenes/Levels/Dungeon_Test_Night.tscn"),
}
=======
@export_dir var scene_entries_dir:String = "res://Scenes/Scene_Manager/Scene_Resources"

#@export_subgroup("Scene Data")
@export var scene_list:Array[SceneEntry] = []
var _lookup:Dictionary = {}

@export_subgroup("Documentation")
@export_multiline var doc_text: String = """""":
	set(_val):
		doc_text = """\
* Refresh Scenes:\nManually reload "Scene List" values.\n
* Scene Entries Dir :\nFolder containing all SceneEntry resources.\n
* Scene List:\nAutomatically populated list of SceneEntry resources."""
		notify_property_list_changed()
	get(): return doc_text
>>>>>>> c29fd9b (1. Remove: amargosa station models)

var next_scene: String = ""
var scene_state:int = 0
var changing_scenes:bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var scenes: Node = $Scenes
#@onready var pause_menu: Control = $Menus/Pause_Menu

func has_scene(_name: String) -> bool:
	return _lookup.has(_name)

func get_scene(_name: String) -> PackedScene:
	return load(_lookup.get(_name, ""))

func _sort_by_name(a: SceneEntry, b: SceneEntry) -> bool:
	return a.name < b.name

func _refresh_scenes():
	scene_list.clear()
	_scan_directory_recursive(scene_entries_dir)
	scene_list.sort_custom(_sort_by_name)
	_build_lookup()

func _scan_directory_recursive(dir_path: String) -> void:
	var dir := DirAccess.open(dir_path)
	if dir == null:
		push_warning("Invalid directory: %s" % dir_path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if dir.current_is_dir():
			if file_name != "." and file_name != "..":
				_scan_directory_recursive(dir_path.path_join(file_name))
		else:
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var path = dir_path.path_join(file_name)
				var res = load(path)
				if res is SceneEntry:
					scene_list.append(res)
		file_name = dir.get_next()

	dir.list_dir_end()

func _build_lookup():
	_lookup.clear()
	for entry in scene_list:
		_lookup[entry.name] = entry.path

func _ready() -> void:
	if Engine.is_editor_hint():
		_refresh_scenes()
	_build_lookup()

	if Engine.is_editor_hint():
		return

	for entry in scene_list:
		_lookup[entry.name] = entry.path

	#if fullscreen: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	animation_player.animation_finished.connect(_on_animation_finished)
	_change_scene("blank")


func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return

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
	if Engine.is_editor_hint():
		return

	if not (animation_player.is_playing() and animation_player.current_animation == "Fade_In"):
		_change_scene(scene)


func _change_scene(scene: String) -> void:
	if Engine.is_editor_hint():
		return

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
	if Engine.is_editor_hint():
		return

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
	if Engine.is_editor_hint():
		return

	print( has_scene(next_scene) )
	#if next_scene in scene_list:
	if has_scene(next_scene):
		#var new_scene = scene_list[next_scene].instantiate()
		var new_scene = get_scene(next_scene).instantiate()
		scenes.add_child(new_scene)


func _remove_scene() -> void:
	if Engine.is_editor_hint():
		return

	SettingsManager._free_ui_items()

	for child in scenes.get_children():
		child.queue_free()
