extends Node

const default_settings:Dictionary = {
	## Display
	"fullscreen": false,
	"vsync": true,
	"fps": 60,

	## Input
	"look_sensitivity": 0.5,

	## Rendering
	"quality_preset": 2,

	## Reflection Probe
	"reflection_probe": true,
	"reflection_probe_realtime": false,

	## SDFGI
	"sdfgi_enabled": false,
	"sdfgi_use_occlusion": false,
	"sdfgi_read_sky_light": false,
	"sdfgi_cascades": 2,
	"sdfgi_min_cell_size": 20.0,

	## SSR
	"ssr_enabled": false,

	## SSIL
	"ssil_enabled": false,

	## SSAO
	"ssao_enabled": true,

	## Volumetric Fog
	"volumetric_fog_enabled": false,

	## Glow
	"glow_enabled": true,
}

const presets:Array = [
	## Potato
	{
		"SSIL": [
			false,
			],
		"SSR": [
			false,
			],
		"SSAO": [
			false,
			],
		"SDFGI": [
			false,
			false,
			false,
			],
		"Glow": [
			false,
			],
		"Volumetric_Fog": [
			false,
			],
	},

	## Mobile
	{
		"SSIL": [
			false,
			],
		"SSR": [
			false,
			],
		"SSAO": [
			false,
			],
		"SDFGI": [
			false,
			false,
			false,
			],
		"Glow": [
			true,
			],
		"Volumetric_Fog": [
			false,
			],
	},

	## Standard
	{
		"SSIL": [
			false,
			],
		"SSR": [
			false,
			],
		"SSAO": [
			true,
			],
		"SDFGI": [
			false,
			false,
			false,
			],
		"Glow": [
			true,
			],
		"Volumetric_Fog": [
			false,
			],
	},

	## Modern
	{
		"SSIL": [
			false,
			],
		"SSR": [
			false,
			],
		"SSAO": [
			true,
			],
		"SDFGI": [
			true,
			false,
			false,
			],
		"Glow": [
			true,
			],
		"Volumetric_Fog": [
			false,
			],
	},

	## Ultra
	{
		"SSIL": [
			false,
			],
		"SSR": [
			true,
			],
		"SSAO": [
			true,
			],
		"SDFGI": [
			true,
			false,
			false,
			],
		"Glow": [
			true,
			],
		"Volumetric_Fog": [
			true,
			],
	},

	## Super Ultra
	{
		"SSIL": [
			true,
			],
		"SSR": [
			true,
			],
		"SSAO": [
			true,
			],
		"SDFGI": [
			true,
			true,
			true,
			],
		"Glow": [
			true,
			],
		"Volumetric_Fog": [
			true,
			],
	},
]

var world_environment:WorldEnvironment
var reflection_probe:ReflectionProbe

var ui_buttons:Array = []

#var effects_list:Array = [
	#"ssil_enabled",
	#"ssao_enabled",
	#"ssr_enabled",
	#"glow_enabled",
	#"volumetric_fog_enabled",
	#"sdfgi_enabled",
	#"sdfgi_use_occlusion",
	#"sdfgi_read_sky_light",
	#"sdfgi_cascades",
	#"sdfgi_min_cell_size",
#]

@onready var settings:Dictionary = default_settings.duplicate(true)
@onready var window_mode:DisplayServer.WindowMode = DisplayServer.window_get_mode()
#@onready var custom_settings:Dictionary = default_settings.duplicate(true)


func _ready() -> void:
	if settings["fullscreen"]: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	#else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

	#await get_tree().process_frame
	_change_graphics_preset()
#
	#await get_tree().process_frame
	_refresh_settings()


func _append_ui_item( _item:Node ) -> void:
	if not _item in ui_buttons:
		ui_buttons.append( _item )


func _free_ui_items() -> void:
	ui_buttons.clear()


#func _refresh_effects() -> void:
	#for _effect:String in effects_list:
		#environment.set(_effect, settings[_effect])


func _change_graphics_preset() -> void:
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

	set_preset( settings["quality_preset"] )


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

	#match settings["quality_preset"]:
		#0:
			#settings["reflection_probe"] = false
			#settings["reflection_probe_realtime"] = false
		#1:
			#settings["reflection_probe"] = true
			#settings["reflection_probe_realtime"] = false
		#2:
			#settings["reflection_probe"] = true
			#settings["reflection_probe_realtime"] = false
		#3:
			#settings["reflection_probe"] = true
			#settings["reflection_probe_realtime"] = false
		#4:
			#settings["reflection_probe"] = true
			#settings["reflection_probe_realtime"] = false
		#5:
			#settings["reflection_probe"] = true
			#settings["reflection_probe_realtime"] = true
		#6:
			#settings["reflection_probe"] = true
			#settings["reflection_probe_realtime"] = true

	if settings["vsync"]:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

	Engine.max_fps = settings["fps"]

	#if world_environment:
#
		### SDFGI
		#world_environment.environment.set( "sdfgi_enabled", settings["sdfgi_enabled"] )
		#world_environment.environment.set( "sdfgi_use_occlusion", settings["sdfgi_use_occlusion"] )
		#world_environment.environment.set( "sdfgi_read_sky_light", settings["sdfgi_read_sky_light"] )
#
		### SSR
		#world_environment.environment.set( "ssr_enabled", settings["ssr_enabled"] )
#
		### SSIL
		#world_environment.environment.set( "ssil_enabled", settings["ssil_enabled"] )
#
		### SSAO
		#world_environment.environment.set( "ssao_enabled", settings["ssao_enabled"] )
#
		### Glow
		#world_environment.environment.set( "glow_enabled", settings["glow_enabled"] )
		##world_environment.set_preset( settings["quality_preset"] )

	if reflection_probe:
		reflection_probe.visible = settings["reflection_probe"]

		match settings["reflection_probe_realtime"]:
			false: reflection_probe.update_mode = ReflectionProbe.UPDATE_ONCE
			true: reflection_probe.update_mode = ReflectionProbe.UPDATE_ALWAYS


	for _button in ui_buttons:
		if is_instance_valid(_button):
			_button._ready()
		else:
			ui_buttons.erase( _button )

	#print( ui_buttons )


func set_preset( _preset:int ) -> void:
	var preset_safety:int = 0

	if presets.size() > _preset:
		preset_safety = _preset
	else: preset_safety = presets.size()-1

	for key in presets[preset_safety]:
		set_key_values( preset_safety, key )

	if world_environment:
		world_environment._refresh_effects()

	#environment.set("ssil_enabled", settings["ssil_enabled"])
	#environment.set("ssao_enabled", settings["ssao_enabled"])
	#environment.set("ssr_enabled", settings["ssr_enabled"])
	#environment.set("glow_enabled", settings["glow_enabled"])
	#environment.set("volumetric_fog_enabled", settings["volumetric_fog_enabled"])
	#environment.set("sdfgi_enabled", settings["sdfgi_enabled"])
	#environment.set("sdfgi_use_occlusion", settings["sdfgi_use_occlusion"])
	#environment.set("sdfgi_read_sky_light", settings["sdfgi_read_sky_light"])
	#environment.set("sdfgi_cascades", settings["sdfgi_cascades"])
	#environment.set("sdfgi_min_cell_size", settings["sdfgi_min_cell_size"])


func set_key_values( _idx:int, _key:String ) -> void:
	#print( _key )
	match _key:
		"SSIL":
			settings["ssil_enabled"] = presets[_idx][_key][0]
			if world_environment:
				world_environment.environment.set("ssil_enabled", presets[_idx][_key][0])
		"SSR":
			settings["ssr_enabled"] = presets[_idx][_key][0]
			if world_environment:
				world_environment.environment.set("ssr_enabled", presets[_idx][_key][0])

		"SSAO":
			settings["ssao_enabled"] = presets[_idx][_key][0]
			if world_environment:
				world_environment.environment.set("ssao_enabled", presets[_idx][_key][0])

		"SDFGI":
			settings["sdfgi_enabled"] = presets[_idx][_key][0]
			settings["sdfgi_use_occlusion"] = presets[_idx][_key][1]
			settings["sdfgi_read_sky_light"] = presets[_idx][_key][2]

			if world_environment:
				world_environment.environment.set("sdfgi_enabled", presets[_idx][_key][0])
			if world_environment:
				world_environment.environment.set("sdfgi_use_occlusion", presets[_idx][_key][1])
			if world_environment:
				world_environment.environment.set("sdfgi_read_sky_light", presets[_idx][_key][2])

		"Glow":
			settings["glow_enabled"] = presets[_idx][_key][0]
			if world_environment:
				world_environment.environment.set("glow_enabled", presets[_idx][_key][0])

		"Volumetric_Fog":
			settings["volumetric_fog_enabled"] = presets[_idx][_key][0]
			if world_environment:
				world_environment.environment.set("volumetric_fog_enabled", presets[_idx][_key][0])
