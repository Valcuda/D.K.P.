extends Spatial

export var debug = true

var lookSensitivity : float = FreeAccessInfo.CameraOrbitSensitivity

var minLookAngle : float = FreeAccessInfo.CameraMinLookAngle
var maxLookAngle : float = FreeAccessInfo.CameraMaxLookAngle

export var cameraDistance : float = 1.0

var mouseDelta : Vector2 = Vector2()

var clamp_camera_view : bool = true
var camera_controls : bool = true

onready var player = get_parent()
onready var cam = get_node("Camera")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	
	if event is InputEventMouseMotion:
		mouseDelta = event.relative	


func _process(delta):
	
	lookSensitivity = FreeAccessInfo.CameraOrbitSensitivity - (-cameraDistance * 0.1)
	
	if Input.is_action_just_pressed("Camera_rot"):
		if camera_controls == false:
			camera_controls = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			camera_controls = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if camera_controls == true:
		var rot = Vector3(mouseDelta.y, mouseDelta.x, 0) * lookSensitivity * delta
		
		rotation_degrees.x += rot.x
		if clamp_camera_view == true:
			rotation_degrees.x = clamp(rotation_degrees.x, minLookAngle - cam.cameraDistance, maxLookAngle)
	
		#player.rotation_degrees.y -= rot.y
		rotation_degrees.y -= rot.y
		
		mouseDelta = Vector2()
		

	if debug == true:
		if Input.is_action_just_pressed("Move_forward"):
			snapToPlay()
	
	if Input.is_key_pressed(16777351) and FreeAccessInfo.Debug == true:
		clamp_camera_view = false

func snapToPlay():
	player.rotation_degrees.y += rotation_degrees.y
	rotation_degrees.y = 0
	pass
	
	
	
	
