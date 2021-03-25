extends KinematicBody

###################-VARIABLES-####################

var compare = preload("res://utils/constants.gd")
var canLight = true

# Camera
var mouse_sensitivity = 9.2
export(NodePath) var head_path
export(NodePath) var cam_path
var FOV = 90.0
var mouse_axis := Vector2()
onready var head: Spatial = get_node(head_path)
onready var cam: Camera = get_node(cam_path)
onready var ap = $Head/Camera/AnimationPlayer
# Move
var velocity := Vector3()
var direction := Vector3()
var move_axis := Vector2()
var sprint_enabled := true
var sprinting := false
# Walk
const FLOOR_MAX_ANGLE: float = deg2rad(46.0)
var gravity = 34.0
var walk_speed = 25
var sprint_speed = 40
var acceleration = 20
var deacceleration = 14
var air_control = .9
var jump_height = 12
# Fly
var fly_speed = 20
var fly_accel = 40
var flying := false
var change_v = false

enum {
	IDLE,
	CAMINANDO,
	CORRIENDO
}
var state = IDLE	

### SIGNALS ###
signal cerillaUsed
##################################################

# Called when the node enters the scene tree
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam.fov = FOV


# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta: float) -> void:
	move_axis.x = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	move_axis.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if is_on_floor() and velocity.length() < 0.56:
		state = IDLE
	elif is_on_floor() and velocity.length() > 0.56 and !sprinting:
		state = CAMINANDO
	elif is_on_floor() and velocity.length() > 0.56 and sprinting:
		state = CORRIENDO
		
	match state: 
		IDLE:
			ap.play("camera_idle")
		CAMINANDO:
			ap.play("walk")
		CORRIENDO:
			ap.play("sprint")

# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	if flying:
		fly(delta)
	else:
		walk(delta)
		
# Called when there is an input event
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_axis = event.relative
		camera_rotation()

func walk(delta: float) -> void:
	# Input
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if move_axis.x >= 0.5:
		direction -= aim.z
	if move_axis.x <= -0.5:
		direction += aim.z
	if move_axis.y <= -0.5:
		direction -= aim.x
	if move_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	
	# Jump
	var _snap: Vector3
	if is_on_floor():
		_snap = Vector3.DOWN
		if Input.is_action_just_pressed("move_jump"):
			_snap = Vector3.ZERO
			velocity.y = jump_height
	
	### USAR CERILLAS	
		
	#if Input.is_action_just_pressed("light_up"):
	#	if get_parent().get_node("MarginContainer/GridContainer/CERILLAS").cerillasContador > compare.cerillasMin and canLight:
	#		canLight = false
	#		$luz/light_booster/Timer.start()
	#		$luz/light_booster.play("luz_boost")
	#		emit_signal("cerillaUsed")
	#	else:
	#		pass
	
	# Apply Gravity
	velocity.y -= gravity * delta
	
	# Sprint
	var _speed: int
	if (Input.is_action_pressed("move_sprint") and can_sprint()):
		_speed = sprint_speed
		cam.set_fov(lerp(cam.fov, FOV * 1.05, delta * 1))
		sprinting = true
	else:
		_speed = walk_speed
		cam.set_fov(lerp(cam.fov, FOV, delta * 1))
		sprinting = false
	
	# Acceleration and Deacceleration
	# where would the player go
	var _temp_vel: Vector3 = velocity
	_temp_vel.y = 0
	var _target: Vector3 = direction * _speed
	var _temp_accel: float
	if direction.dot(_temp_vel) > 0:
		_temp_accel = acceleration
	else:
		_temp_accel = deacceleration
	if not is_on_floor():
		_temp_accel *= air_control
	# interpolation
	_temp_vel = _temp_vel.linear_interpolate(_target, _temp_accel * delta)
	velocity.x = _temp_vel.x
	velocity.z = _temp_vel.z
	# clamping (to stop on slopes)
	if direction.dot(velocity) == 0:
		var _vel_clamp := 0.25
		if abs(velocity.x) < _vel_clamp:
			velocity.x = 0
		if abs(velocity.z) < _vel_clamp:
			velocity.z = 0
	
	# Move
	var moving = move_and_slide_with_snap(velocity, _snap, Vector3.UP, true, 4, FLOOR_MAX_ANGLE)
	if is_on_wall():
		velocity = moving
	else:
		velocity.y = moving.y


func fly(delta: float) -> void:
	# Input
	direction = Vector3()
	var aim = head.get_global_transform().basis
	if move_axis.x >= 0.5:
		direction -= aim.z
	if move_axis.x <= -0.5:
		direction += aim.z
	if move_axis.y <= -0.5:
		direction -= aim.x
	if move_axis.y >= 0.5:
		direction += aim.x
		
	direction = direction.normalized()
	
	# Acceleration and Deacceleration
	var target: Vector3 = direction * fly_speed
	velocity = velocity.linear_interpolate(target, fly_accel * delta)
	
	# Move
	velocity = move_and_slide(velocity)


func camera_rotation() -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if mouse_axis.length() > 0:
		var horizontal: float = -mouse_axis.x * (mouse_sensitivity / 100)
		var vertical: float = -mouse_axis.y * (mouse_sensitivity / 100)
		
		mouse_axis = Vector2()
		
		rotate_y(deg2rad(horizontal))
		head.rotate_x(deg2rad(vertical))
		
		# Clamp mouse rotation
		var temp_rot: Vector3 = head.rotation_degrees
		temp_rot.x = clamp(temp_rot.x, -90, 90)
		head.rotation_degrees = temp_rot
		

func can_sprint() -> bool:
	var moving = velocity.length() > 0.57
	return (sprint_enabled and moving and is_on_floor())


func _on_Timer_timeout():
	canLight = true


func _on_Ladder_body_entered(body):
	if body.name == "Player":
		velocity.y = 10

