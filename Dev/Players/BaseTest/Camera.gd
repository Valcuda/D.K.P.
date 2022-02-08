extends Camera

pass

var scrollSensitivity : float = FreeAccessInfo.CameraScrollSensitivity

var cameraDistance: float = -5.0
var mindistance : float = FreeAccessInfo.CameraMinDistance
var maxdistance : float = FreeAccessInfo.CameraMaxDistance

onready var camorbit = get_parent()

#Debug
var clamp_camera_dist : bool = true

func _input(event):
	
	if Input.is_action_pressed("Camera_zoomIn"):
		cameraDistance = cameraDistance + scrollSensitivity
	if Input.is_action_pressed("Camera_zoomOut"):
		cameraDistance = cameraDistance - scrollSensitivity
	
	if clamp_camera_dist == true:
		cameraDistance = clamp(cameraDistance, maxdistance, mindistance)
	
	camorbit.cameraDistance = cameraDistance

	
func _physics_process(delta):
	self.translation.z = cameraDistance
	
	if Input.is_key_pressed(16777352) and FreeAccessInfo.Debug == true:
		clamp_camera_dist = false
