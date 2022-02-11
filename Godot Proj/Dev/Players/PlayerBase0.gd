class_name PlayerBase_0 extends MainPlayerController_0

#DONT CHANGE THE GAME ID.
#This allows the character to be easily ported into another game.
const GameID: int = 0

#CHANGE CharacterID IN PLAYER SCRIPT
#This allows the game to differentiate between each character
#The Tens value should change for each unique player, while the ones value should be for different forms.
#All Values begining with 1 are reserved for BaseTest_
var CharacterID: int = 10

func _onready():
	pass


func _physics_process(delta):
	nonlinear_player_controler()
	pass

#This is basically a finite state machine, minus the GUI, cause Godot doesn't allow for easy FNMs
func nonlinear_player_controler():
	match cur_state:
		CurState.RUN:
			if Input.is_action_just_pressed("Move_jump") and canJump and is_on_floor():
				snap_vector = Vector3.ZERO
				velocity.y = jump_impulse
				has_jumped = true
				velocity = move_and_slide_with_snap(velocity,  snap_vector, Vector3.UP, true)
				change_state(CurState.JUMP)
			
			if not is_on_floor():
				change_state(CurState.INAIR)
		
		CurState.INAIR:
			if is_on_floor():
				change_state(CurState.RUN)
			
	
	pass

func change_state(state):
	cur_state = state
	pass
