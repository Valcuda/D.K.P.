extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_Test1_pressed():
	FreeAccessInfo.LoadThisScene("res://Scenes/Test Levels/TestLevel1.tscn", "def")
	pass # Replace with function body.


func _on_Start_Test2_pressed():
	FreeAccessInfo.LoadThisScene("res://Scenes/Test Levels/TestLevel2.tscn", "def")
	pass # Replace with function body.
