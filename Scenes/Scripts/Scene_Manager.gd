extends Control

#var fullscreen:bool = false

const scene_list := {
	"Blank": preload("res://Scenes/Blank.tscn"),
	"Amargosa": preload("res://Scenes/Levels/Ambargosa_Station.tscn"),
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
	_change_scene("Blank")


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


func _skip_transition(scene: String) -> void:
	if not (animation_player.is_playing() and animation_player.current_animation == "Fade_In"):
		_change_scene(scene)


func _change_scene(scene: String) -> void:
	if scene == "Quit":
		changing_scenes = false
		next_scene = "Quit"
		animation_player.play("Fade_Out")
	else:
		changing_scenes = true
		if next_scene != scene:
			next_scene = scene
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
	for child in scenes.get_children():
		child.queue_free()
