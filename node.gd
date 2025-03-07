extends Area2D
func _on_area_entered(body):
	if body.name=="character":
		print("estoy tocando personaje")
