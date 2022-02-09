extends Spatial

onready var player = get_node("PlayerBaseTest")
onready var player_X = get_node("Debug GUI/Panel/Player X")
onready var player_Y = get_node("Debug GUI/Panel/Player Y")
onready var player_Z = get_node("Debug GUI/Panel/Player Z")
onready var player_current_state = get_node("Debug GUI/Panel/Player State")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if FreeAccessInfo.Debug:
		var player_pos = player.get_position_in_parent()
		var px = player_pos
#		var py = player_pos.y
#		var pz = player_pos.z
		
		var p_state = player.cur_state
		var p_textstate = "Unknown"
		
		player_X.text = str(px)
#		player_Y.text = py
#		player_Z.text = pz
		
		match p_state:
			player.CurState.ATTACK:
				p_textstate = "Attack"
			player.CurState.CLIMB:
				p_textstate = "Climb"
			player.CurState.DEAD:
				p_textstate = "Dead"
			player.CurState.INAIR:
				p_textstate = "In Air"
			player.CurState.JUMP:
				p_textstate = "Jump"
			player.CurState.RIDE:
				p_textstate = "Ride"
			player.CurState.RUN:
				p_textstate = "Run"
		
		player_current_state.text = p_textstate
		
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
