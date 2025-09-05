extends Node

const default_settings:Dictionary = {
	## Display
	"fullscreen": true,
	"vsync": true,
	"fps": 60,
	## Rendering
	"quality_preset": 1,
}

var world_environment:WorldEnvironment

@onready var settings:Dictionary = default_settings.duplicate(true)
#@onready var custom_settings:Dictionary = default_settings.duplicate(true)


func _ready() -> void:
	if settings["fullscreen"]: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	#else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

	_refresh_settings()


func _refresh_settings() -> void:

	if settings["fullscreen"]:
		if not DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		if not DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

	if world_environment:
		world_environment.set_preset( settings["quality_preset"] )
