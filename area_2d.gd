extends Area2D
@export var tipo ="none"
@export var sprite= "uuuuu"
@export var destiny = null

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body.name== "Player":
		body.change_terreno(tipo, self)
	if tipo=="entrada_vacio":
		destiny=get_parent().get_node("Entrada")
		print("la pocision si la tengo", destiny.name) 
