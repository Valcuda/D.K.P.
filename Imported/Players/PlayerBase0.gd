class_name PlayerBase_0 extends MainPlayerController_0

#DONT CHANGE THE GAME ID.
#This allows the character to be easily ported into another game.
const GameID: int = 0

#CHANGE CharacterID IN PLAYER SCRIPT
#This allows the game to differentiate between each character
#The Tens value should change for each unique player, while the ones value should be for different forms.
export var CharacterID: int = 10

func _onready():
	pass

#This is basically a finite state machine, minus the GUI, cause Godot doesn't allow for easy FNMs
func nonlinear_player_controler():
	pass
