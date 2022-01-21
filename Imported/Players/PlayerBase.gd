class_name Player_Base extends KinematicBody

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
