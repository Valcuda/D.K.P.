extends Node

#imported from Epics Awesome Adventure, by Dakota Willey
var VersionType = "Alpha"
var BuildNumber : float = 0.1
var PatchNumber = 0

#Debug
var Debug : bool = true
var IgnoreCharacterUnlocks : bool = true
var InfMode : bool = true


var BaseTest = preload("res://Dev/Players/BaseTest/PlayerBaseTest.tscn")

#Controls
var CameraOrbitSensitivity : float = 10.0
var CameraScrollSensitivity : float = 0.5

var CameraMinLookAngle : float = -19.0
var CameraMaxLookAngle : float = 75.0

var CameraMinDistance : float = -2
var CameraMaxDistance : float = -13
var CameraZoomSensitivity: float = 0.7

#New Level Loading

func LoadThisScene(NScene, NSpawn):
	get_tree().change_scene(NScene)
	pass
