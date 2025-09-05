extends Node3D

class_name WeaponSlot

@export var model : Node3D
@export var weaponId : int
@export var attackPoint : Marker3D
@export var muzzleFlashSpawner : Marker3D
#@export var target_node:Marker3D
#@export var model_node:Node3D

#@onready var parent:Node3D = get_parent()


#func _process(_delta: float) -> void:
	#if not target_node:
		#return
#
	#var target_position = target_node.global_transform.origin
	#var up_vector = Vector3.UP
	#look_at(target_position, up_vector)
