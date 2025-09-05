extends CheckBox


func _ready() -> void:
	set_pressed_no_signal(SettingsManager.settings["fullscreen"])


func _toggled(_toggle: bool) -> void:
	SettingsManager.settings["fullscreen"] = _toggle
	SettingsManager._refresh_settings()
