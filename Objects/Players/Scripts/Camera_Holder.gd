extends Node3D

@export_group("Nodes")
@export var playChar: CharacterBody3D
@export var camera: Camera3D
@export var weaponManager: Node3D

@export_group("Camera variables")
@export_range(0.0, 5.0, 0.01) var XAxisSens: float = 0.12
@export_range(0.0, 5.0, 0.01) var YAxisSens: float = 0.12
@export var maxUpAngleView: float = -90.0
@export var maxDownAngleView: float = 90.0

@export_group("FOV variables")
@export var startFOV: float = 50.0
@export var runFOV: float = 90.0
@export var fovTransitionSpeed: float = 3.0

@export_group("Movement changes variables")
@export var baseCamAngle: float
@export var crouchCamAngle: float
@export var baseCameraLerpSpeed: float = 8.0
@export var crouchCameraLerpSpeed: float = 8.0
@export var crouchCameraDepth: float = -0.4

@export_group("Camera bob variables")
@export var enableBob: bool = true
var headBobValue: float
@export var bobFrequency: float = 0.9
@export var bobAmplitude: float = 0.01

@export_group("Camera tilt variables")
@export var enableTilt: bool = true
@export var tiltRotationValue: float = 0.6
@export var tiltRotationSpeed: float = 2.0
@export var inAirTiltValDivider: float = 1.9

@export_group("Input variables")
var mouseInput: Vector2
@export var mouseInputSpeed: float = 10.0

# We now let the Body script handle yaw/pitch.
# This script only handles bob & tilt so it won’t fight rotations.

func _process(delta: float) -> void:
	cameraBob(delta)
	cameraTilt(delta)

func cameraBob(delta: float) -> void:
	if enableBob and playChar:
		headBobValue += delta * playChar.velocity.length() * float(playChar.is_on_floor())
		if camera:
			transform.origin = headbob(headBobValue, bobFrequency, bobAmplitude)

func headbob(time: float, bobFreq: float, bobAmpli: float) -> Vector3:
	var pos := Vector3.ZERO
	pos.y = sin(time * bobFreq) * bobAmpli
	pos.x = cos(time * bobFreq / 2.0) * bobAmpli
	return pos

func cameraTilt(delta: float) -> void:
	if not enableTilt or playChar == null:
		return

	# Derive lateral movement along the player's local right axis
	var right := playChar.global_transform.basis.x
	right.y = 0.0
	right = right.normalized()
	var horiz_vel := Vector3(playChar.velocity.x, 0.0, playChar.velocity.z)
	var lateral_speed := horiz_vel.dot(right) # negative = moving left, positive = right

	var target_tilt = -clamp(lateral_speed, -1.0, 1.0) * tiltRotationValue
	if not playChar.is_on_floor():
		target_tilt /= inAirTiltValDivider

	rotation.z = lerp(rotation.z, target_tilt, tiltRotationSpeed * delta)
