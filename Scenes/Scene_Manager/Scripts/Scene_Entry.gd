@tool
class_name SceneEntry
extends Resource

@export var name: String :
	set(_val): name = _val.replace(" ", "_").to_lower()
	get(): return name.replace(" ", "_").to_lower()

@export_file("*.tscn") var path: String
