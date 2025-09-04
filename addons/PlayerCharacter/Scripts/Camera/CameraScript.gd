extends Node3D

#class name
class_name CameraObject

@export_group("Nodes")
@export var _playChar:Node3D

@export_group("Camera variables")
@export_range(0.0, 5.0, 0.01) var XAxisSens : float = 0.12
@export_range(0.0, 5.0, 0.01) var YAxisSens : float = 0.12
@export var maxUpAngleView : float = -50
@export var maxDownAngleView : float = 50

@export_group("FOV variables")
@export var startFOV : float = 50
@export var runFOV : float = 90
@export var fovTransitionSpeed : float = 3

@export_group("Movement changes variables")
@export var baseCamAngle : float = 0
@export var crouchCamAngle : float = 0
@export var baseCameraLerpSpeed : float = 8
@export var crouchCameraLerpSpeed : float = 8
@export var crouchCameraDepth : float = -0.4

@export_group("Camera bob variables")
@export var enableBob : bool = true
var headBobValue : float
@export var bobFrequency : float = 2.9
@export var bobAmplitude : float = 0.03

@export_group("Camera tilt variables")
@export var enableTilt : bool = true
@export var tiltRotationValue : float = 0.25
@export var tiltRotationSpeed : float = 1.5
@export var inAirTiltValDivider : float = 1.9

@export_group("Input variables")
var mouseInput : Vector2
@export var mouseInputSpeed : float = 10
var playCharInputDir : Vector2

#Mouse variables
var mouseFree : bool = false
var target_rotation_y: float = 0.0
var target_camera_pitch: float = 0.0

## Controller
var look_input:Vector2 = Vector2.ZERO
var move_input_deadzone:float = 0.08
var look_speed:Vector2 = Vector2( 25, 15 )
var look_sensitivity = 0.002
var look_lerp:float = 0.35
const joysticks:Array = [ "look_up", "look_down", "look_left", "look_right" ]

@export_group("Keybind variables")
@export var mouseModeAction : String = "mouseMode"

#References variables
@onready var camera : Camera3D = %Camera
@onready var playChar : Node3D = _playChar
@onready var weaponManager : Node3D = %WeaponManager

func _ready():
	#$CameraRecoilHolder/Camera.rotation.y = 90
	#target_rotation_y = rotation.y

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var viewport_size = get_viewport().size
	var center_position = viewport_size / 2
	Input.warp_mouse(center_position)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().set_input_as_handled()


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		target_rotation_y -= event.relative.x * (XAxisSens / 80.0)
		target_camera_pitch -= event.relative.y * (YAxisSens / 80.0)

		target_camera_pitch = clamp(target_camera_pitch, deg_to_rad(maxUpAngleView), deg_to_rad(maxDownAngleView))


func _process(delta):
	#smooth_camera_look(delta)
#
	#_controller_look(delta)

	applies(delta)

	cameraBob(delta)

	cameraTilt(delta)


#func _controller_look( _delta:float ) -> void:
	#look_input.x = Input.get_action_strength("look_up") - Input.get_action_strength("look_down")
	#look_input.y = Input.get_action_strength("look_left") - Input.get_action_strength("look_right")
#
	#if Vector2.ZERO.distance_to(look_input) > move_input_deadzone*sqrt(2.0):
		#look_lerp = 0.32
		#target_rotation_y += look_speed.x * look_input.y * look_sensitivity
		#target_camera_pitch += look_speed.y * look_input.x * look_sensitivity


#func smooth_camera_look( delta:float ) -> void:
	## Smoothly rotate body (yaw)
	#var current_yaw = rotation.y
	#current_yaw = lerp_angle(current_yaw, target_rotation_y, delta * 15.0)
	#rotation.y = current_yaw
#
	## Smoothly rotate camera (pitch)
	#var current_pitch = camera.rotation.x
	#current_pitch = lerp_angle(current_pitch, target_camera_pitch, delta * 15.0)
	#camera.rotation.x = current_pitch


func applies(delta : float):
	#manage the differents camera modifications relative to a specific state, except for the FOV
	if playChar.stateMachine and playChar.stateMachine.currStateName == "Crouch":
		position.y = lerp(position.y, 0.715 + crouchCameraDepth, crouchCameraLerpSpeed * delta)
		rotation.z = lerp(rotation.z, deg_to_rad(crouchCamAngle) * playChar.inputDirection.x if playChar.inputDirection.x != 0.0 else deg_to_rad(crouchCamAngle), crouchCameraLerpSpeed * delta)
	elif playChar.stateMachine and playChar.stateMachine.currStateName == "Run":
		camera.fov = lerp(camera.fov, runFOV, fovTransitionSpeed * delta)
		rotation.z = lerp(rotation.z, deg_to_rad(baseCamAngle), baseCameraLerpSpeed * delta)
	elif playChar.stateMachine and playChar.stateMachine.currStateName == "Jump":
		# Maintain the current FOV when jumping
		camera.fov = lerp(camera.fov, camera.fov, fovTransitionSpeed * delta)
	elif playChar.stateMachine and playChar.stateMachine.currStateName == "Inair":
		# Maintain the current FOV when in air
		camera.fov = lerp(camera.fov, camera.fov, fovTransitionSpeed * delta)
	else:
		position.y = lerp(position.y, 0.715, baseCameraLerpSpeed * delta)
		rotation.z = lerp(rotation.z, deg_to_rad(baseCamAngle), baseCameraLerpSpeed * delta)
		camera.fov = lerp(camera.fov, startFOV, fovTransitionSpeed * delta)

func cameraBob(delta):
	if enableBob:
		headBobValue += delta * playChar.velocity.length() * float(playChar.is_on_floor())
		camera.transform.origin = headbob(headBobValue, bobFrequency, bobAmplitude)

func headbob(time, bobFreq, bobAmpli):
	#some trigonometry stuff here, basically it uses the cosinus and sinus functions (sinusoidal function) to get a nice and smooth bob effect
	var pos = Vector3.ZERO
	pos.y = sin(time * bobFreq) * bobAmpli
	pos.x = cos(time * bobFreq / 2) * bobAmpli
	return pos

func cameraTilt(delta):
	if enableTilt:
		#this function manage the camera tilting when the character is moving on the x axis (left and right)
		if playChar.moveDirection != Vector3.ZERO and playChar.inputDirection != Vector2.ZERO:
			playCharInputDir = playChar.inputDirection #get input direction to know where the character is heading to
			#apply smooth tilt movement
			if !playChar.is_on_floor(): rotation.z = lerp(rotation.z, -playCharInputDir.x * tiltRotationValue/inAirTiltValDivider, tiltRotationSpeed * delta)
			else: rotation.z = lerp(rotation.z, -playCharInputDir.x * tiltRotationValue, tiltRotationSpeed * delta)

func mouseMode():
	#manage the mouse mode (visible = can use mouse on the screen, captured = mouse not visible and locked in at the center of the screen)
	if Input.is_action_just_pressed(mouseModeAction): mouseFree = !mouseFree
	if !mouseFree: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
