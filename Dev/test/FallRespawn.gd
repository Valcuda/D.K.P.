extends Spatial


func _ready():
	pass # Replace with function body.


func _on_Area_area_entered(area):
	get_node(".")
	pass # Replace with function body.


func _on_Area_body_entered(body):
	body.translation = self.translation
	pass # Replace with function body.
