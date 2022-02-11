extends KinematicBody


var vel : Vector3 = Vector3.ZERO
var direction : Vector3 = Vector3.ZERO

var slow : float = 4
var initSpeed : float = 20.0
var gravity : float = 3.0
var linger : float = 1.5

onready var timer = get_node("Timer")

func _ready():
	timer.connect("timeout", self, "_on_Timer_timeout")
	pass # Replace with function body.

func begin(dir):
	direction = dir
	vel = dir * initSpeed

func _physics_process(delta):
	
	if vel.x > 0:
		vel.x -= slow * delta
		vel.x = clamp(vel.x, 0, 1000)
	
	if vel.z > 0:
		vel.z -= slow * delta
		vel.z = clamp(vel.z, 0, 1000)
	
	if vel.x < 0:
		vel.x += slow * delta
		vel.x = clamp(vel.x, -1000, 0)
	
	if vel.z < 0:
		vel.z += slow * delta
		vel.z = clamp(vel.z, -1000, 0)
	
	vel.y -= gravity * delta
	
	
	vel = move_and_slide(vel, Vector3.UP)
	
	if vel.x == 0 and vel.z == 0:
		timer.start(1)



func _on_Timer_timeout():
	queue_free()


func _on_HurtBox_area_entered(area):
	queue_free()
	pass # Replace with function body.
