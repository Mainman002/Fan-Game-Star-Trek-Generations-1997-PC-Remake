extends WorldEnvironment

const presets:Array = [
	## Potato
	{
		"SSR": [
			false
			],
		"SSAO": [
			false
			],
		"SDFGI": [
			false
			],
		"Glow": [
			false
			],
		"Volumetric_Fog": [
			false
			],
	},

	## Mobile
	{
		"SSR": [
			false
			],
		"SSAO": [
			false
			],
		"SDFGI": [
			false
			],
		"Glow": [
			true
			],
		"Volumetric_Fog": [
			false
			],
	},

	## Standard
	{
		"SSR": [
			false
			],
		"SSAO": [
			true
			],
		"SDFGI": [
			false
			],
		"Glow": [
			true
			],
		"Volumetric_Fog": [
			false
			],
	},

	## Modern
	{
		"SSR": [
			false
			],
		"SSAO": [
			true
			],
		"SDFGI": [
			true
			],
		"Glow": [
			true
			],
		"Volumetric_Fog": [
			true
			],
	},

	## Ultra
	{
		"SSR": [
			true
			],
		"SSAO": [
			true
			],
		"SDFGI": [
			true
			],
		"Glow": [
			true
			],
		"Volumetric_Fog": [
			true
			],
	},
]


#var current_preset:int = 2


func _ready() -> void:
	set_preset( 1 )


#func refresh_preset() -> void:
	#set_preset( current_preset )


func set_preset( _preset:int ) -> void:
	var preset_safety:int = 0

	if presets.size() > _preset:
		preset_safety = _preset
	else: preset_safety = presets.size()-1

	for key in presets[preset_safety]:
		set_key_values( preset_safety, key )


func set_key_values( _idx:int, _key:String ) -> void:
	#print( _key )
	match _key:
		"SSR":
			environment.set("ssr_enabled", presets[_idx][_key][0])
		"SSAO":
			environment.set("ssao_enabled", presets[_idx][_key][0])
		"SDFGI":
			environment.set("sdfgi_enabled", presets[_idx][_key][0])
		"Glow":
			environment.set("glow_enabled", presets[_idx][_key][0])
		"Volumetric_Fog":
			environment.set("volumetric_fog_enabled", presets[_idx][_key][0])
