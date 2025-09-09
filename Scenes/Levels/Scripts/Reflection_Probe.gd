extends ReflectionProbe

func _ready() -> void:
	SettingsManager.reflection_probe = self
	SettingsManager._refresh_settings()
