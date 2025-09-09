extends Button

var SceneManager:Node = null

func _ready() -> void:
	if get_tree().root.has_node("Scene_Manager"):
		SceneManager = get_tree().root.get_node("Scene_Manager")

func _pressed() -> void:
	disabled = true
	if SceneManager: SceneManager._change_scene("Quit")
	else: get_tree().quit()
