class_name MainPlayerController_0 extends KinematicBody

export var max_speed = 10.0
export var acceleration = 70.0
export var friction = 60.0
export var air_friction = 10.0
export var gravity = -40.0
export var jump_impulse = 20.0
export(bool) var canRun = false
export(float) var runAdjust = 5.0

var camUpperBound = 75.0
var camLowerBound = -75.0
var camZoomUpper = 12.0
var camZoomLower = 2.0
var camZoomSpeed = 1.0
var mouse_sensitivity = .1
var controller_sensitivity = 3.0
var rot_speed = 30.0

var velocity = Vector3.ZERO
var snap_vector = Vector3.ZERO

onready var pivot = $Pivot
onready var spring_arm = $SpringArm

#active variables
var isRunning = false
var canJump = true
var should_fall = true

var SpeedAdjustments = 0
var curMaxSpeed = max_speed
var LastInputVector = Vector3.ZERO
var LastDirection = Vector3.ZERO
var jump_done = true
var has_jumped = false

enum CurState {
	RUN,
	CLIMB,
	RIDE,
	INAIR,
	JUMP,
	ATTACK,
	DEAD,
}

var cur_state = CurState.RUN
var return_state = CurState.RUN


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _unhandled_input(event):
	if event.is_action_pressed("CamControlToggle"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		spring_arm.rotate_x(deg2rad(event.relative.y * mouse_sensitivity))
		

func _physics_process(delta):
	state_man(delta)
	
	spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg2rad(camLowerBound), deg2rad(camUpperBound))
	pass


func get_direction(input_vector):
	var direction = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	return direction
	
func apply_movement(input_vector, direction, delta):
	curMaxSpeed = max_speed + SpeedAdjustments
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * curMaxSpeed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * curMaxSpeed, acceleration * delta).z
		#pivot.look_at(global_transform.origin + direction, Vector3.UP)
		pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(input_vector.x, input_vector.z), rot_speed * delta)

func apply_friction(direction, delta):
	if direction == Vector3.ZERO:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			velocity.x = velocity.move_toward(direction * curMaxSpeed, air_friction * delta).x
			velocity.z = velocity.move_toward(direction * curMaxSpeed, air_friction * delta).z

func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, gravity, jump_impulse)
	
func update_snap_vector():
	snap_vector = -get_floor_normal() if is_on_floor() else Vector3.DOWN
	
func state_man(delta):
	match cur_state:
		CurState.RUN:
			run()
			var input_vector = get_input_vector()
			LastInputVector = input_vector
			var direction = get_direction(input_vector)
			apply_movement(input_vector, direction, delta)
			apply_friction(direction, delta)
			apply_gravity(delta)
			update_snap_vector()
			velocity = move_and_slide_with_snap(velocity,  snap_vector, Vector3.UP, true)
			
		CurState.INAIR:
			apply_movement(LastInputVector, LastDirection, delta)
			apply_gravity(delta)
			update_snap_vector()
			velocity = move_and_slide_with_snap(velocity,  snap_vector, Vector3.UP, true)
			
		CurState.CLIMB:
			pass
		
		CurState.DEAD:
			pass
		
		CurState.RIDE:
			pass
			
		CurState.ATTACK:
			pass
		
		CurState.JUMP:
			if Input.is_action_just_pressed("Move_jump") and is_on_floor() and canJump:
				snap_vector = Vector3.ZERO
				velocity.y = jump_impulse
			elif Input.is_action_just_released("Move_jump") and velocity.y > jump_impulse / 2:
				velocity.y = jump_impulse / 2
			if not is_on_floor():
				jump_done = true
			if jump_done:
				jump_done = false
				cur_state = CurState.INAIR
	pass

		
func apply_controller_rotation():
	var axis_vector = Vector2.ZERO
	axis_vector.x = Input.get_action_strength("look_left") - Input.get_action_strength("look_right")
	axis_vector.y = Input.get_action_strength("look_forward") - Input.get_action_strength("look_backward")
	
	if InputEventJoypadMotion:
		rotate_y(deg2rad(axis_vector.x) * controller_sensitivity)
		spring_arm.rotate_x(deg2rad(axis_vector.y) * controller_sensitivity)

func get_input_vector(): #Responsible for ground movement
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("Move_left") - Input.get_action_strength("Move_right")
	input_vector.z = Input.get_action_strength("Move_forward") - Input.get_action_strength("Move_backward")
	return input_vector.normalized() if input_vector.length() > 1 else input_vector

func run(): #Responisble for increasing speed when running
	if Input.is_action_just_pressed("Move_run") and canRun and isRunning == false:
		isRunning = true
		SpeedAdjustments += runAdjust
	
	if Input.is_action_just_released("Move_run") and isRunning:
		isRunning = false
		SpeedAdjustments -= runAdjust

func jump():
#	if Input.is_action_pressed("Move_jump") and is_on_floor() and canJump and has_jumped == false:
#		snap_vector = Vector3.ZERO
#		velocity.y = jump_impulse
#		has_jumped = true
	if Input.is_action_just_released("Move_jump") and velocity.y > jump_impulse / 2:
		velocity.y = jump_impulse / 2
	if is_on_floor() == false:
		jump_done = true
		print("jump_done is true")
	if is_on_floor() and jump_done:
		cur_state = CurState.INAIR
	velocity = move_and_slide_with_snap(velocity,  snap_vector, Vector3.UP, true)
