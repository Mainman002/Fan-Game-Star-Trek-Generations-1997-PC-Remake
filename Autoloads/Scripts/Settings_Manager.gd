extends Node

const default_settings:Dictionary = {
	## Display
	"fullscreen": false,
	"vsync": true,
	"fps": 60,
	## Rendering
	"quality_preset": 1,
	"reflection_probe": true,
	"reflection_probe_realtime": false,
}

var world_environment:WorldEnvironment
var reflection_probe:ReflectionProbe

@onready var settings:Dictionary = default_settings.duplicate(true)
@onready var window_mode:DisplayServer.WindowMode = DisplayServer.window_get_mode()
#@onready var custom_settings:Dictionary = default_settings.duplicate(true)


func _ready() -> void:
	if settings["fullscreen"]: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	#else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

	_refresh_settings()


func _refresh_settings() -> void:
	#var window_mode := DisplayServer.window_get_mode()

	if settings["fullscreen"]:
		if not window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
			DisplayServer.window_set_mode( window_mode )
	else:
		if not window_mode == DisplayServer.WINDOW_MODE_MAXIMIZED:
			window_mode = DisplayServer.WINDOW_MODE_MAXIMIZED
			DisplayServer.window_set_mode( window_mode )

	#if settings["fullscreen"]:
		#if not DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	#else:
		#if not DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

	match settings["quality_preset"]:
		0:
			settings["reflection_probe"] = false
			settings["reflection_probe_realtime"] = false
		1:
			settings["reflection_probe"] = true
			settings["reflection_probe_realtime"] = false
		2:
			settings["reflection_probe"] = true
			settings["reflection_probe_realtime"] = false
		3:
			settings["reflection_probe"] = true
			settings["reflection_probe_realtime"] = false
		4:
			settings["reflection_probe"] = true
			settings["reflection_probe_realtime"] = false
		5:
			settings["reflection_probe"] = true
			settings["reflection_probe_realtime"] = true
		6:
			settings["reflection_probe"] = true
			settings["reflection_probe_realtime"] = true

	if world_environment:
		world_environment.set_preset( settings["quality_preset"] )

	if reflection_probe:
		reflection_probe.visible = settings["reflection_probe"]

		match settings["reflection_probe_realtime"]:
			false: reflection_probe.update_mode = ReflectionProbe.UPDATE_ONCE
			true: reflection_probe.update_mode = ReflectionProbe.UPDATE_ALWAYS
