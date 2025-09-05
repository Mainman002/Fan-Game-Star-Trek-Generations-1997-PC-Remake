extends CharacterBody3D

@export_category("Nodes")
@export var camera:Camera3D
@export var camera_holder:Node3D
@export var stateMachine:Node
@export var flashlight:SpotLight3D

@export_category("Movement")
@export_subgroup("Physics")
@export var gravity:float = -0.28
@export var fallLimit:float = -8

@export_subgroup("Jump")
@export var jumpMax:int = 1
@export var jumpForce:float = -0.9

@export_category("Speed")
#var moveSpeed : float = 4.0
#var moveAccel : float = 8.0
#var moveDeccel : float = 10.0
#var desiredMoveSpeed : float
#@export var moveGroundSpeed:float = 3

@export_subgroup("Walk")
@export var walkSpeed : float = 4.0
@export var walkAirSpeed:float = 4.25
#@export var walkAccel : float = 8.0
#@export var walkDeccel : float = 9.0

@export_subgroup("Run")
@export var runSpeed : float = 6.0
@export var runAirSpeed : float = 6.25
#@export var runAccel : float = 7.0
#@export var runDeccel : float = 10.0
#@export var continiousRun : bool = false

@export_category("Camera")
@export_subgroup("Variables")
@export var fov:int = 55
@onready var fov_walk:int = fov
@export var fov_sprint:int = 75

var current_weapon:String = "Knife"
var weapons:Dictionary = {
	#"Knife": AssetManager.meshes["Knife_01"].duplicate(),
	}
var weapon_icons:Dictionary = {
	#"Knife": preload("res://Images/UI/Knife.png"),
	}

#var isThrowing:bool = false
#var canAutoFire:bool = false
#var auto_fire:bool = false

var isMovingX:bool = false
var isMovingZ:bool = false
var isGrounded:bool = false
var isSprinting:bool = false
var jumpCount:int = jumpMax
var moveDir:Vector3i = Vector3i.ZERO
var inputDirection : Vector2
var moveDirection : Vector3

## Controller
var look_input:Vector2 = Vector2.ZERO
var move_input:Vector2 = Vector2.ZERO
var controller_moving:Vector2 = Vector2.ZERO
var move_input_deadzone:float = 0.08
var look_speed:Vector2 = Vector2( 25, 15 )
var look_sensitivity = 0.002
var look_lerp:float = 0.35
const joysticks:Array = [ "look_up", "look_down", "look_left", "look_right" ]
const move_joysticks:Array = [ "L_joy_up", "L_joy_down", "L_joy_left", "L_joy_right" ]

## Camera Variables
var trauma:float = 0.0
var trauma_power:int = 3
var decay:float = 0.9
var max_roll:Vector3 = Vector3(0.25, 0.25, 0.25)
var max_offset:Vector3 = Vector3(3, 3, 0)

## Look Variables
var mouse_sensitivity:float = 0.002
var yaw:float = 0.0
var pitch:float = 0.0
@export var maxUpAngle:float = -89.0
@export var maxDownAngle:float = 80.0
@onready var nextMouseRotation:Vector3 = %Camera.rotation
#@onready var camera_ui: Camera3D = $SubViewportContainer/SubViewport/ViewportCam


func _ready() -> void:
	yaw = rotation.y

	#await get_tree().process_frame
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	#set move variables, and value references
	#moveSpeed = walkSpeed
	#moveAccel = walkAccel
	#moveDeccel = walkDeccel

	#hitGroundCooldownRef = hitGroundCooldown
	#jumpCooldownRef = jumpCooldown
	#nbJumpsInAirAllowedRef = nbJumpsInAirAllowed
	#coyoteJumpCooldownRef = coyoteJumpCooldown

	$CameraHolder.startFOV = fov
	$CameraHolder.runFOV = fov + 10
	$CameraHolder/CameraRecoilHolder/Camera.fov = fov
	$SubViewportContainer/SubViewport/ViewportCam.fov = fov

	#yaw = 0.0
	##camera.transform.basis.z = -transform.basis.z
	##nextMouseRotation.x = rotation.x
	##nextMouseRotation.y = 0.0
#
	#$Model.queue_free()
	#_sync_stats()
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#for joy in joysticks:
		#InputMap.action_set_deadzone(joy, move_input_deadzone)
#
	#camera.fov = fov
	##camera_ui.fov = fov



func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("start_button"):
		#if not has_node("/root/Scene_Manager"):
		#get_tree().quit()
		#else:
			#PlayerStats._reset_stats()
			#get_node("/root/Scene_Manager")._change_scene( "Level_Select" )
			#get_node("/root/Scene_Manager")._play_sound("click")

	#if Input.is_action_just_pressed("run"):
		#isSprinting = not isSprinting

	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(maxUpAngle), deg_to_rad(maxDownAngle))

	#if event is InputEventMouseMotion:
		#look_lerp = 0.25
		#nextMouseRotation.y += -event.relative.x * mouse_sensitivity
		#nextMouseRotation.x += -event.relative.y * mouse_sensitivity

	#if event is InputEventMouseButton:
		#if canAutoFire:
			#auto_fire = event.button_index == MOUSE_BUTTON_LEFT
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if not isThrowing && not canAutoFire:
				#var new_knife:Node = weapons[ current_weapon ].instantiate()
				#new_knife.position = $FPS_Camera/Camera3D/Hand.global_position
				#new_knife.rotation = $FPS_Camera.rotation
				#if not get_tree().root.has_node("Projectiles"):
					#var new_projectiles:Node3D = Node3D.new()
					#new_projectiles.name = "Projectiles"
					#get_tree().root.add_child( new_projectiles )
					#get_tree().root.get_node("Projectiles").add_child( new_knife )
				#else:
					#get_tree().root.get_node("Projectiles").add_child( new_knife )
				#new_knife._apply_impulse( $FPS_Camera, 15.0 )
			#isThrowing = not isThrowing


func _process(delta: float) -> void:
	#var forward:Vector3 = -transform.basis.z
	#forward.y = 0
	#forward = forward.normalized()
#
	#var right:Vector3 = -transform.basis.x
	#right.y = 0
	#right = right.normalized()

	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

	#isSprinting = not Input.is_action_pressed("run")
	isGrounded = is_on_floor()

	# Gravity
	if not isGrounded:
		velocity.y += gravity
	if velocity.y < fallLimit:
		velocity.y = fallLimit

	## Keyboard / Mouse
	_camera_look( delta )
	_on_ground( delta )
	_in_air( delta )

	## Controller
	_controller_look( delta )
	#_controller_move( delta )
	#_controller_on_ground( delta )

	if isGrounded && Input.is_action_just_pressed("jump"):
		if jumpCount > 0:
			_apply_vertical_impulse( 1, -jumpForce*10 )
			jumpCount -= 1
	#elif Input.is_action_just_pressed("jump"):
		#if jumpCount > 0:
			#_apply_vertical_impulse( 1, -jumpForce*10 )
			#jumpCount -= 1
	#elif Input.is_action_just_released("jump"):
		#if velocity.y > 0: velocity.y = lerpf( velocity.y, 0, 0.4 )

	if Input.is_action_just_pressed("run"):
		isSprinting = not isSprinting

	if Input.is_action_just_pressed("flashlight"):
		flashlight.visible = not flashlight.visible

	if isSprinting: change_fov(fov_sprint, delta)
	else: change_fov(fov_walk, delta)

	if velocity.y < fallLimit: velocity.y = fallLimit
	move_and_slide()


func _on_ground( _delta: float ) -> void:
	if isGrounded:
		jumpCount = jumpMax

		inputDirection = Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBackward")
		var forward:Vector3 = transform.basis.z
		forward.y = 0
		forward = forward.normalized()

		var right:Vector3 = transform.basis.x
		right.y = 0
		right = right.normalized()

		moveDirection = (forward * inputDirection.y + right * inputDirection.x).normalized()

		# Horizontal movement
		if moveDirection != Vector3.ZERO:
			if isGrounded:
				var speed
				if isSprinting:
					#speed = moveGroundSpeed * 1.25
					speed = runSpeed
				else:
					#speed = moveGroundSpeed
					speed = walkSpeed

				velocity.x = moveDirection.x * speed
				velocity.z = moveDirection.z * speed
			else:
				var speed
				if isSprinting:
					speed = runSpeed
					#speed = moveGroundSpeed * 1.25
				else:
					speed = walkSpeed
					#speed = moveGroundSpeed
				velocity.x = moveDirection.x * speed
				velocity.z = moveDirection.z * speed
		else:
			if isGrounded:
				velocity.x = move_toward(velocity.x, 0, walkSpeed)
				velocity.z = move_toward(velocity.z, 0, walkSpeed)
				#velocity.x = move_toward(velocity.x, 0, moveGroundSpeed)
				#velocity.z = move_toward(velocity.z, 0, moveGroundSpeed)


#func _controller_on_ground( _delta: float ) -> void:
	#if isGrounded:
		#jumpCount = jumpMax
#
		#inputDirection = Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBackward")
		#var forward:Vector3 = transform.basis.z
		#forward.y = 0
		#forward = forward.normalized()
#
		#var right:Vector3 = transform.basis.x
		#right.y = 0
		#right = right.normalized()
#
		#moveDirection = (forward * inputDirection.y + right * inputDirection.x).normalized()
#
		## Horizontal movement
		#if moveDirection != Vector3.ZERO:
			#if isGrounded:
				#var speed
				#if isSprinting:
					##speed = moveGroundSpeed * 1.25
					#speed = runSpeed
				#else:
					##speed = moveGroundSpeed
					#speed = walkSpeed
#
				#speed = speed * controller_moving.y
				#velocity.x = moveDirection.x * speed
				#velocity.z = moveDirection.z * speed
			#else:
				#var speed
				#if isSprinting:
					#speed = runSpeed
					##speed = moveGroundSpeed * 1.25
				#else:
					#speed = walkSpeed
					##speed = moveGroundSpeed
				#speed = speed * controller_moving.y
				#velocity.x = moveDirection.x * speed
				#velocity.z = moveDirection.z * speed
		#else:
			#if isGrounded:
				#velocity.x = move_toward(velocity.x, 0, walkSpeed)
				#velocity.z = move_toward(velocity.z, 0, walkSpeed)
				##velocity.x = move_toward(velocity.x, 0, moveGroundSpeed)
				##velocity.z = move_toward(velocity.z, 0, moveGroundSpeed)


func _in_air( _delta: float ) -> void:
	if not isGrounded:
		if Input.is_action_just_pressed("jump"):
			if jumpCount > 0:
				_apply_vertical_impulse( 1, -jumpForce*10 )
				jumpCount -= 1
		elif Input.is_action_just_released("jump"):
			if velocity.y > 0: velocity.y = lerpf( velocity.y, 0, 0.4 )

		inputDirection = Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBackward")

		# Get forward & right vectors from the *body’s yaw* (not full camera basis)
		var forward:Vector3 = transform.basis.z
		forward.y = 0
		forward = forward.normalized()

		var right:Vector3 = transform.basis.x
		right.y = 0
		right = right.normalized()

		moveDirection = (forward * inputDirection.y + right * inputDirection.x).normalized()

		velocity.y += gravity

		var _inputDirection:Vector2 = Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBackward")
		var _direction:Vector3 = (camera.transform.basis * Vector3( -_inputDirection.y, 0, _inputDirection.x) ).normalized()

		# Horizontal movement
		if moveDirection != Vector3.ZERO:
			if isGrounded:
				var speed
				if isSprinting:
					speed = runAirSpeed
					#speed = moveGroundSpeed * 2
				else:
					speed = walkAirSpeed
					#speed = moveGroundSpeed

				velocity.x = moveDirection.x * speed
				velocity.z = moveDirection.z * speed
			else:
				var speed
				if isSprinting:
					speed = runAirSpeed
					#speed = moveGroundSpeed * 2
				else:
					speed = walkAirSpeed
					#speed = moveGroundSpeed
				velocity.x = moveDirection.x * speed
				velocity.z = moveDirection.z * speed
		else:
			if isGrounded:
				velocity.x = move_toward(velocity.x, 0, walkSpeed)
				velocity.z = move_toward(velocity.z, 0, walkSpeed)
				#velocity.x = move_toward(velocity.x, 0, moveGroundSpeed)
				#velocity.z = move_toward(velocity.z, 0, moveGroundSpeed)

		#if _direction:
			#if isSprinting:
				#velocity.x = _direction.x * (moveAirSpeed * 2)
				#velocity.z = _direction.z * (moveAirSpeed * 2)
			#else:
				#velocity.x = _direction.x * (moveAirSpeed * 1)
				#velocity.z = _direction.z * (moveAirSpeed * 1)
		#else:
			#velocity.x = 0
			#velocity.z = 0

		#if SettingsManager.settings["wall_slide"]:
			#if is_on_wall():
				#velocity.y = velocity.y * 0.5
				#jumpCount = jumpMax
#
				#if jumpCount > 0 && Input.is_action_just_pressed("jump"):
					#if test_move( transform, Vector3(0.1*_direction.x, 0, 0.1*_direction.z)):
						#_apply_horizontal_impulse( int(-_direction.x), -jumpForce*4 )
						#_apply_vertical_impulse( 1, -jumpForce*5 )
		#else:
		if is_on_wall():
			if test_move( transform, Vector3(0.1*-_direction.x, 0, 0.1*-_direction.z)):
				velocity.x = 0
				velocity.z = 0

		#if isMovingX || isMovingZ: $AnimatedSprite3D.play("Jump")
		#else: $AnimatedSprite3D.play("Jump")
		#$AnimatedSprite3D.speed_scale = 0


func _camera_look( _delta:float ) -> void:
	# Rotate the player body horizontally (yaw only)
	rotation.y = lerp_angle(rotation.y, yaw, look_lerp)

	# Rotate the camera vertically (pitch only)
	var cam_rot = camera.rotation
	cam_rot.x = lerp(cam_rot.x, pitch, look_lerp)
	camera.rotation = cam_rot

	#camera.rotation.y = lerp( camera.rotation.y, nextMouseRotation.y, look_lerp )
	#camera.rotation.x = lerp( camera.rotation.x, nextMouseRotation.x, look_lerp )


func _controller_look( _delta:float ) -> void:
	look_input.x = Input.get_action_strength("look_up") - Input.get_action_strength("look_down")
	look_input.y = Input.get_action_strength("look_left") - Input.get_action_strength("look_right")


	if Vector2.ZERO.distance_to(look_input) > move_input_deadzone*sqrt(2.0):
		yaw += look_speed.y * look_input.y * _delta * 0.14 ## Horizontal
		pitch += look_speed.x * look_input.x * _delta * 0.085 ## Vertical
		pitch = clamp(pitch, deg_to_rad(maxUpAngle), deg_to_rad(maxDownAngle))
		#var cam_rot = camera.rotation
		#look_lerp = 0.32
		#cam_rot.x = lerp(cam_rot.x, pitch, look_lerp)
		#camera.rotation = cam_rot

		#rotation.y += look_speed.x * look_input.y * look_sensitivity
		#nextMouseRotation.x += look_speed.y * look_input.x * look_sensitivity


#func _controller_move( _delta:float ) -> void:
	#move_input.x = Input.get_action_strength("L_joy_up") - Input.get_action_strength("L_joy_down")
	#move_input.y = Input.get_action_strength("L_joy_left") - Input.get_action_strength("L_joy_right")
#
#
	#if Vector2.ZERO.distance_to(move_input) > move_input_deadzone*sqrt(2.0):
		#print( move_input )
		#controller_moving = move_input

		#yaw += look_speed.y * move_input.y * _delta * 0.14 ## Horizontal
		#pitch += look_speed.x * move_input.x * _delta * 0.085 ## Vertical
		#pitch = clamp(pitch, deg_to_rad(maxUpAngle), deg_to_rad(maxDownAngle))


func _apply_vertical_impulse( _direction:int=1, _force:float=4.3 ) -> void:
	velocity.y = 0
	velocity.y += _force * _direction


func _apply_horizontal_impulse( _direction:int=1, _force:float=4.3 ) -> void:
	velocity.x = 0
	moveDir.x = _direction
	velocity.x += _force * _direction


func _apply_impulse( _direction:Vector2i=Vector2i.ZERO, _force:Vector2=Vector2.ZERO ) -> void:
	if not _direction.y == 0:
		velocity.y = 0
		moveDir.y = _direction.y
		velocity.y += _force.y * _direction.y

	if not _direction.x == 0:
		velocity.x = 0
		moveDir.x = _direction.x
		velocity.x += _force.x * _direction.x
		await get_tree().create_timer(0.4).timeout
		moveDir.x = 0


func _sync_stats() -> void:
	#gravity = PlayerStats.stats["gravity"]
	#fallLimit = PlayerStats.stats["fallLimit"]
	#jumpMax = PlayerStats.stats["jumpMax"]
	#jumpForce = PlayerStats.stats["jumpForce"]
	#moveGroundSpeed = PlayerStats.stats["moveGroundSpeed"]
	#moveAirSpeed = PlayerStats.stats["moveAirSpeed"]
	jumpCount = jumpMax


func _increase_jump_limit() -> void:
	jumpMax += 1
	jumpCount = jumpMax
	jumpForce += -0.05
	#PlayerStats.stats["jumpMax"] = jumpMax
	#PlayerStats.stats["jumpForce"] = jumpForce


func die() -> void:
	queue_free()
	#$"../%Smooth_Camera3D".trauma = 0.5


func change_fov( _fov:float, delta:float ) -> void:
	var temp_fov:float = camera.fov
	temp_fov = lerp(temp_fov, _fov, 0.2 * delta * velocity.length())
	camera.fov = temp_fov
	$CameraHolder/CameraRecoilHolder/Camera.fov = temp_fov
	$SubViewportContainer/SubViewport/ViewportCam.fov = temp_fov


func shake() -> void:
	var _amount:float = pow(trauma, trauma_power)
	rotation = max_roll * _amount * randf_range( -1, 1)
	camera.h_offset = max_offset.x * _amount * randf_range( -1, 1)
	camera.v_offset = max_offset.y * _amount * randf_range( -1, 1)


func Percent( _current:float, _max:float, _decimal:int ) -> float:
	# Get a percentage between 2 values with a decimal
	if _current == 0: return 0.0
	else: return (_current / _max) * _decimal


func _change_weapon( _key:String ) -> void:
	current_weapon = _key
	$%Weapon_Preview.texture = weapon_icons[ _key ]
	$%Weapon_Label.text = str( _key )
