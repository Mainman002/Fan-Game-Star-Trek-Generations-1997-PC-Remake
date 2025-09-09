extends HSlider


func _ready() -> void:
	set_value_no_signal(SettingsManager.settings["quality_preset"])


func _value_changed( _value: float ) -> void:
	SettingsManager.settings["quality_preset"] = int(_value)
	SettingsManager._refresh_settings()
