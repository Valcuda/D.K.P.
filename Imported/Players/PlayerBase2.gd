class_name Player_Base_New extends KinematicBody

export var CID : String = "0"
var Cinfo = GlobalCharInfo.nfochar_0

export var clampVelocity : bool = true

export var maxHp : int = 100
export var meleeDamage : int = 100
export var rangedDamage : int = 100
export var luck : int = 50

export var attackRate : float = 50
export var lastAttackTime : int = 0

export var acceleration : float = 10
export var maxSpeed : float = 10
export var jumpForce : float = 15
export var gravity : float = 2.5
export var friction : float = 1
export var runMulti : float = 2.5

export var canDoubleJump : bool = false

#active variables
var curHp : int = 100

var JumpEnable : bool = true
var DJumpReady : bool = false

var airIntent : bool = false

var vel : Vector3 = Vector3()

var is_moving = false
var is_running = false

onready var camera = get_node("CameraOrbit")
onready var true_camera = get_node("CameraOrbit/Camera")
var Bullet = preload("res://Dev/projectiles/debugle_gum.tscn")
	

func _physics_process(delta):
	vel.x = 0
	vel.z = 0
	
	var input = Vector3()
	input = BaseInputDetection(input)
	
	if input == Vector3.ZERO:
		is_moving = false
	else:
		is_moving = true
	
	if Input.is_action_pressed("Move_run"):
		is_running = true
	
	if Input.is_action_just_released("Move_run"):
		is_running = false
	
	if is_on_floor() and [airIntent] or [canDoubleJump and DJumpReady == false]:
		DJumpReady = true
		airIntent = false
	
	#debug
	#return to title screen
	if Input.is_action_just_pressed("ui_cancel") and FreeAccessInfo.Debug == true:
		
		pass
	#manually lock/unlock velocity clamp
	if Input.is_key_pressed(16777350) and FreeAccessInfo.Debug == true:
		clampVelocity = false
		pass
	
	input = input.normalized()
	
	var dir = (transform.basis.z * input.z + transform.basis.x * input.x)
	
	if Input.is_action_just_pressed("Attack_ranged"):
		var correctAngle : Vector3 = Vector3(-0.1, 0, -0.1)
		var thisdir = (transform.basis.z + transform.basis.x * correctAngle)
		var newtrans : Vector3 = self.translation
		newtrans.y += 1
		var curProject = Bullet.instance()
		get_parent().add_child(curProject)
		curProject.global_translate(newtrans)
		curProject.begin(thisdir)
		pass
	
	vel.x = dir.x * acceleration
	vel.z = dir.z * acceleration
#	if vel.z != 0:
#		if vel.z >= moveSpeed:
#			vel.z = moveSpeed
#		elif vel.z >= 1:
#			vel.z -= friction
#		elif vel.z <= -1:
#			vel.z += friction
#		else:
#			vel.z = 0
#	if vel.x != 0:
#		if vel.x >= moveSpeed:
#			vel.x = moveSpeed
#		elif vel.x >= 1:
#			vel.x -= friction
#		elif vel.x <= -1:
#			vel.x += friction
#		else:
#			vel.x = 0
	
	if is_running == true:
		vel.x = vel.x * runMulti
		vel.z = vel.z * runMulti
	
	vel.y -= gravity * delta
	
	if Input.is_action_just_pressed("Move_jump") and JumpEnable:
		if is_on_floor():
			vel.y = jumpForce
			airIntent = true
		elif canDoubleJump and DJumpReady:
			vel.y = jumpForce
			DJumpReady = false
			airIntent = true
	
	if clampVelocity == true:
		vel.y = clamp(vel.y, -1000, 30)
		vel.x = clamp(vel.x, -30, 30)
		vel.z = clamp(vel.z, -30, 30)
	
	if is_moving == true:
		camera.snapToPlay()
		is_moving = false
	
	vel = move_and_slide(vel, Vector3.UP)
	
	if Input.is_key_pressed(16777353) and FreeAccessInfo.Debug == true:
		get_tree().change_scene("res://worlds/test levels/TestLevel02.tscn")
		pass
		
	if Input.is_key_pressed(16777356) and FreeAccessInfo.Debug == true:
		get_tree().change_scene("res://worlds/test levels/TestLevel03.tscn")
		pass


func BaseInputDetection(input):
		
	if Input.is_action_pressed("Move_forward"):
		input.z += 1
		#is_moving = true
	if Input.is_action_pressed("Move_backward"):
		input.z -= 1
		#is_moving = true
	if Input.is_action_pressed("Move_left"):
		input.x += 1
		#is_moving = true
	if Input.is_action_pressed("Move_right"):
		input.x -= 1
		#is_moving = true
	
	return input
