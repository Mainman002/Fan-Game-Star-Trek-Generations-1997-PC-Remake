extends Node3D

#class name
class_name CameraObject

@export_group("Camera variables")
@export_range(0.0, 5.0, 0.01) var XAxisSens : float
@export_range(0.0, 5.0, 0.01) var YAxisSens : float
@export var maxUpAngleView : float
@export var maxDownAngleView : float

@export_group("FOV variables")
@export var startFOV : float
@export var runFOV : float
@export var fovTransitionSpeed : float

@export_group("Movement changes variables")
@export var baseCamAngle : float
@export var crouchCamAngle : float
@export var baseCameraLerpSpeed : float
@export var crouchCameraLerpSpeed : float
@export var crouchCameraDepth : float

@export_group("Camera bob variables")
@export var enableBob : bool = true
var headBobValue : float
@export var bobFrequency : float
@export var bobAmplitude : float

@export_group("Camera tilt variables")
@export var enableTilt : bool = true
@export var tiltRotationValue : float
@export var tiltRotationSpeed : float
@export var inAirTiltValDivider : float

@export_group("Input variables")
var mouseInput : Vector2
@export var mouseInputSpeed : float
var playCharInputDir : Vector2

#Mouse variables
var mouseFree : bool = false
var target_rotation_y: float = 0.0
var target_camera_pitch: float = 0.0

@export_group("Keybind variables")
@export var mouseModeAction : String = ""

#References variables
@onready var camera : Camera3D = %Camera
@onready var playChar : PlayerCharacter = $".."
@onready var weaponManager : Node3D = %WeaponManager

func _ready():
	target_rotation_y = rotation.y

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #set mouse as captured
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
	smooth_camera_look(delta)

	applies(delta)

	cameraBob(delta)

	cameraTilt(delta)


func smooth_camera_look( delta:float ) -> void:
	# Smoothly rotate body (yaw)
	var current_yaw = rotation.y
	current_yaw = lerp_angle(current_yaw, target_rotation_y, delta * 15.0)
	rotation.y = current_yaw

	# Smoothly rotate camera (pitch)
	var current_pitch = camera.rotation.x
	current_pitch = lerp_angle(current_pitch, target_camera_pitch, delta * 15.0)
	camera.rotation.x = current_pitch


func applies(delta : float):
	#manage the differents camera modifications relative to a specific state, except for the FOV
	if playChar.stateMachine.currStateName == "Crouch":
		position.y = lerp(position.y, 0.715 + crouchCameraDepth, crouchCameraLerpSpeed * delta)
		rotation.z = lerp(rotation.z, deg_to_rad(crouchCamAngle) * playChar.inputDirection.x if playChar.inputDirection.x != 0.0 else deg_to_rad(crouchCamAngle), crouchCameraLerpSpeed * delta)
	elif playChar.stateMachine.currStateName == "Run":
		camera.fov = lerp(camera.fov, runFOV, fovTransitionSpeed * delta)
		rotation.z = lerp(rotation.z, deg_to_rad(baseCamAngle), baseCameraLerpSpeed * delta)
	elif playChar.stateMachine.currStateName == "Jump":
		# Maintain the current FOV when jumping
		camera.fov = lerp(camera.fov, camera.fov, fovTransitionSpeed * delta)
	elif playChar.stateMachine.currStateName == "Inair":
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
