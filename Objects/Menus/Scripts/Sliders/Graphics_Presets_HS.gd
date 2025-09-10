extends HSlider


@export var value_label:Label
@export var setting_key:String
@export var value_type:int = 0


func _init() -> void:
	SettingsManager._append_ui_item( self )


func _ready() -> void:
	SettingsManager._append_ui_item( self )

	if value_label:
		value_label.text = str(value)

	set_value_no_signal(SettingsManager.settings[setting_key])


func _value_changed( _value: float ) -> void:
	match value_type:
		0: SettingsManager.settings[setting_key] = float(_value)
		1: SettingsManager.settings[setting_key] = int(_value)
		3: SettingsManager.settings[setting_key] = str(_value)

	if value_label:
		value_label.text = str(value)

	if setting_key == "quality_preset":
		SettingsManager._change_graphics_preset()

	SettingsManager._refresh_settings()
