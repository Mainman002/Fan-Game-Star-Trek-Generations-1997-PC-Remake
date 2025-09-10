extends WorldEnvironment

#const presets:Array = [
	### Potato
	#{
		#"SSIL": [
			#false,
			#],
		#"SSR": [
			#false,
			#],
		#"SSAO": [
			#false,
			#],
		#"SDFGI": [
			#false,
			#false,
			#false,
			#],
		#"Glow": [
			#false,
			#],
		#"Volumetric_Fog": [
			#false,
			#],
	#},
#
	### Mobile
	#{
		#"SSIL": [
			#false,
			#],
		#"SSR": [
			#false,
			#],
		#"SSAO": [
			#false,
			#],
		#"SDFGI": [
			#false,
			#false,
			#false,
			#],
		#"Glow": [
			#true,
			#],
		#"Volumetric_Fog": [
			#false,
			#],
	#},
#
	### Standard
	#{
		#"SSIL": [
			#false,
			#],
		#"SSR": [
			#false,
			#],
		#"SSAO": [
			#true,
			#],
		#"SDFGI": [
			#false,
			#false,
			#false,
			#],
		#"Glow": [
			#true,
			#],
		#"Volumetric_Fog": [
			#false,
			#],
	#},
#
	### Modern
	#{
		#"SSIL": [
			#false,
			#],
		#"SSR": [
			#false,
			#],
		#"SSAO": [
			#true,
			#],
		#"SDFGI": [
			#true,
			#false,
			#false,
			#],
		#"Glow": [
			#true,
			#],
		#"Volumetric_Fog": [
			#false,
			#],
	#},
#
	### Ultra
	#{
		#"SSIL": [
			#false,
			#],
		#"SSR": [
			#true,
			#],
		#"SSAO": [
			#true,
			#],
		#"SDFGI": [
			#true,
			#false,
			#false,
			#],
		#"Glow": [
			#true,
			#],
		#"Volumetric_Fog": [
			#true,
			#],
	#},
#
	### Super Ultra
	#{
		#"SSIL": [
			#true,
			#],
		#"SSR": [
			#true,
			#],
		#"SSAO": [
			#true,
			#],
		#"SDFGI": [
			#true,
			#true,
			#true,
			#],
		#"Glow": [
			#true,
			#],
		#"Volumetric_Fog": [
			#true,
			#],
	#},
#]


var effects_list:Array = [
	"ssil_enabled",
	"ssao_enabled",
	"ssr_enabled",
	"glow_enabled",
	"volumetric_fog_enabled",
	"sdfgi_enabled",
	"sdfgi_use_occlusion",
	"sdfgi_read_sky_light",
	"sdfgi_cascades",
	"sdfgi_min_cell_size",
]

#var current_preset:int = 2


func _ready() -> void:
	SettingsManager.world_environment = self

	_refresh_effects()

	#SettingsManager._refresh_settings()

	#set_preset( 2 )

	#environment.set("ssil_enabled", SettingsManager.settings["ssil_enabled"])
	#environment.set("ssao_enabled", SettingsManager.settings["ssao_enabled"])
	#environment.set("ssr_enabled", SettingsManager.settings["ssr_enabled"])
	#environment.set("glow_enabled", SettingsManager.settings["glow_enabled"])
	#environment.set("volumetric_fog_enabled", SettingsManager.settings["volumetric_fog_enabled"])
	#environment.set("sdfgi_enabled", SettingsManager.settings["sdfgi_enabled"])
	#environment.set("sdfgi_use_occlusion", SettingsManager.settings["sdfgi_use_occlusion"])
	#environment.set("sdfgi_read_sky_light", SettingsManager.settings["sdfgi_read_sky_light"])
	#environment.set("sdfgi_cascades", SettingsManager.settings["sdfgi_cascades"])
	#environment.set("sdfgi_min_cell_size", SettingsManager.settings["sdfgi_min_cell_size"])


func _refresh_effects() -> void:
	for _effect:String in effects_list:
		environment.set(_effect, SettingsManager.settings[_effect])

	#SettingsManager._refresh_settings()


#func refresh_preset() -> void:
	#set_preset( current_preset )


#func set_preset( _preset:int ) -> void:
	#var preset_safety:int = 0
#
	#if SettingsManager.presets.size() > _preset:
		#preset_safety = _preset
	#else: preset_safety = SettingsManager.presets.size()-1
#
	#for key in SettingsManager.presets[preset_safety]:
		#set_key_values( preset_safety, key )
#
	#_refresh_effects()
#
	##environment.set("ssil_enabled", SettingsManager.settings["ssil_enabled"])
	##environment.set("ssao_enabled", SettingsManager.settings["ssao_enabled"])
	##environment.set("ssr_enabled", SettingsManager.settings["ssr_enabled"])
	##environment.set("glow_enabled", SettingsManager.settings["glow_enabled"])
	##environment.set("volumetric_fog_enabled", SettingsManager.settings["volumetric_fog_enabled"])
	##environment.set("sdfgi_enabled", SettingsManager.settings["sdfgi_enabled"])
	##environment.set("sdfgi_use_occlusion", SettingsManager.settings["sdfgi_use_occlusion"])
	##environment.set("sdfgi_read_sky_light", SettingsManager.settings["sdfgi_read_sky_light"])
	##environment.set("sdfgi_cascades", SettingsManager.settings["sdfgi_cascades"])
	##environment.set("sdfgi_min_cell_size", SettingsManager.settings["sdfgi_min_cell_size"])
#
#
#func set_key_values( _idx:int, _key:String ) -> void:
	##print( _key )
	#match _key:
		#"SSIL":
			#SettingsManager.settings["ssil_enabled"] = SettingsManager.presets[_idx][_key][0]
			#environment.set("ssil_enabled", SettingsManager.presets[_idx][_key][0])
		#"SSR":
			#SettingsManager.settings["ssr_enabled"] = SettingsManager.presets[_idx][_key][0]
			#environment.set("ssr_enabled", SettingsManager.presets[_idx][_key][0])
#
		#"SSAO":
			#SettingsManager.settings["ssao_enabled"] = SettingsManager.presets[_idx][_key][0]
			#environment.set("ssao_enabled", SettingsManager.presets[_idx][_key][0])
#
		#"SDFGI":
			#SettingsManager.settings["sdfgi_enabled"] = SettingsManager.presets[_idx][_key][0]
			#SettingsManager.settings["sdfgi_use_occlusion"] = SettingsManager.presets[_idx][_key][1]
			#SettingsManager.settings["sdfgi_read_sky_light"] = SettingsManager.presets[_idx][_key][2]
#
			#environment.set("sdfgi_enabled", SettingsManager.presets[_idx][_key][0])
			#environment.set("sdfgi_use_occlusion", SettingsManager.presets[_idx][_key][1])
			#environment.set("sdfgi_read_sky_light", SettingsManager.presets[_idx][_key][2])
#
		#"Glow":
			#SettingsManager.settings["glow_enabled"] = SettingsManager.presets[_idx][_key][0]
			#environment.set("glow_enabled", SettingsManager.presets[_idx][_key][0])
#
		#"Volumetric_Fog":
			#SettingsManager.settings["volumetric_fog_enabled"] = SettingsManager.presets[_idx][_key][0]
			#environment.set("volumetric_fog_enabled", SettingsManager.presets[_idx][_key][0])
