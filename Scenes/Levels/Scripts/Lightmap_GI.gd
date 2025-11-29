extends LightmapGI

func _ready() -> void:
	SettingsManager.lightmap_gi = self
	SettingsManager._refresh_settings()
