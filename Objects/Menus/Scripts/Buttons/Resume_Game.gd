extends Button


@onready var pause_menu: Control = $"../../../../.."


func _pressed() -> void:
	pause_menu.hide_menu()
