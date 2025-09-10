extends CheckBox

@export var setting_key:String


func _init() -> void:
	SettingsManager._append_ui_item( self )


func _ready() -> void:
	SettingsManager._append_ui_item( self )
	set_pressed_no_signal(SettingsManager.settings[setting_key])


func _toggled(_toggle: bool) -> void:
	SettingsManager.settings[setting_key] = _toggle
	SettingsManager._refresh_settings()
