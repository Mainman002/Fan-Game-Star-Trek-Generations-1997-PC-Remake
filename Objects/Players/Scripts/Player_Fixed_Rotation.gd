extends CharacterBody3D

@export_category("Nodes")
@export var camera:Camera3D

@export_category("Movement")
@export_subgroup("Physics")
@export var gravity:float = -0.5
@export var fallLimit:float = -8

@export_subgroup("Jump")
@export var jumpMax:int = 1
@export var jumpForce:float = -0.9

@export_subgroup("Speed")
@export var moveGroundSpeed:float = 2.5
@export var moveAirSpeed:float = 2

@export_subgroup("Camera")
@export var fov:int = 60

var isGrounded:bool = false
var isSprinting:bool = false
var jumpCount:int = jumpMax

## Look
var mouse_sensitivity:float = 0.002
var look_lerp:float = 0.25
var yaw:float = 0.0
var pitch:float = 0.0
@export var maxUpAngle:float = -89.0
@export var maxDownAngle:float = 89.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.fov = fov


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(maxUpAngle), deg_to_rad(maxDownAngle))


func _process(delta: float) -> void:
	# Rotate the player body horizontally (yaw only)
	rotation.y = lerp_angle(rotation.y, yaw, look_lerp)

	# Rotate the camera vertically (pitch only)
	var cam_rot = camera.rotation
	cam_rot.x = lerp(cam_rot.x, pitch, look_lerp)
	camera.rotation = cam_rot


func _physics_process(delta: float) -> void:
	isGrounded = is_on_floor()

	var input_dir:Vector2 = Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBackward")

	# Get forward & right vectors from the *body’s yaw* (not full camera basis)
	var forward:Vector3 = -transform.basis.z
	forward.y = 0
	forward = forward.normalized()

	var right:Vector3 = transform.basis.x
	right.y = 0
	right = right.normalized()

	var move_dir:Vector3 = (forward * input_dir.y + right * input_dir.x).normalized()

	# Horizontal movement
	if move_dir != Vector3.ZERO:
		if isGrounded:
			var speed
			if isSprinting:
				speed = moveGroundSpeed * 2
			else:
				speed = moveGroundSpeed

			velocity.x = move_dir.x * speed
			velocity.z = move_dir.z * speed
		else:
			var speed
			if isSprinting:
				speed = moveGroundSpeed * 2
			else:
				speed = moveGroundSpeed
			velocity.x = move_dir.x * speed
			velocity.z = move_dir.z * speed
	else:
		if isGrounded:
			velocity.x = move_toward(velocity.x, 0, moveGroundSpeed)
			velocity.z = move_toward(velocity.z, 0, moveGroundSpeed)

	# Gravity
	if not isGrounded:
		velocity.y += gravity
	if velocity.y < fallLimit:
		velocity.y = fallLimit

	# Jump
	if Input.is_action_just_pressed("jump") and jumpCount > 0:
		velocity.y = -jumpForce * 10
		jumpCount -= 1
	elif isGrounded:
		jumpCount = jumpMax

	move_and_slide()
