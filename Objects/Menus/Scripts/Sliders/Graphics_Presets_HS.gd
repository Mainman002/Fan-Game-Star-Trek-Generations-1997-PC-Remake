extends HSlider


func _value_changed( _value: float ) -> void:
	SettingsManager.settings["quality_preset"] = int(_value)
	SettingsManager._refresh_settings()
