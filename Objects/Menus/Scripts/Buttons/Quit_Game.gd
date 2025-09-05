extends Button

@onready var SceneManager:Node = get_tree().root.get_node("Scene_Manager")

func _pressed() -> void:
	disabled = true
	SceneManager._change_scene("Quit")
