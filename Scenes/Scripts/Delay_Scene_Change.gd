extends Node

@export var next_scene:String = "Blank"
@export var delay_time:float = 2.0

var skipping:bool = false

@onready var SceneManager:Node = get_tree().root.get_node("Scene_Manager")

func _ready() -> void:
	if not skipping:
		await get_tree().create_timer( delay_time ).timeout
		SceneManager._change_scene(next_scene)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch || event is InputEventKey:
		skipping = true
		SceneManager._skip_transition(next_scene)
