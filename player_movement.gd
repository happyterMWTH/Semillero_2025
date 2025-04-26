extends CharacterBody2D
class_name Player

@export var SPEED = 300.0
@export var ACCEL = 25
@export var DashCooldown: Timer 

var canDash: bool = true
<<<<<<< Updated upstream

	
=======
var canMove:bool=true
var auto_move: bool=false
var terreno="none"
var destiny =null



>>>>>>> Stashed changes
func get_input() -> Vector2:
	var x := Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var y := Input.get_action_strength("Down") - Input.get_action_strength("Up")
	return Vector2(x,y).normalized()


<<<<<<< Updated upstream
func dash() -> void:
	velocity = velocity * 20


func _physics_process(delta: float) -> void:
	
	var playerInput := get_input()
	
	# Find which direction is bigger and lock it there
	if abs(playerInput.x) > abs(playerInput.y):
		playerInput.y = 0
	else:
		playerInput.x = 0

	velocity = lerp(velocity, playerInput * SPEED, delta * ACCEL)
	
	if Input.is_action_just_pressed("Dash") and canDash:
		canDash = false
		DashCooldown.start()
		dash()

	move_and_slide()
=======
func dash(direction: Vector2) -> void:
	velocity = DASH_MULTIPLIER * SPEED * direction
func Caer():
	print ("Estoy cayendo")
	

func _physics_process(delta: float) -> void:
	
	if canMove==true:
		var playerInput := get_input()
		
		# Find which direction is bigger and lock it there
		if abs(playerInput.x) >= abs(playerInput.y):
			playerInput.y = 0
		else:
			playerInput.x = 0

		
		velocity = lerp(velocity, playerInput * SPEED, delta * ACCEL)
		

		if Input.is_action_just_pressed("Dash") and canDash and energy >= ENERGY_PER_DASH:
			energy -= ENERGY_PER_DASH
			canDash = false
			DashCooldown.start()
			dash(playerInput)

		if energy < MAX_ENERGY:
			energy += (log(energy) / log(1.5) + 1) * delta 
			energy = clamp(energy, 1, MAX_ENERGY)	
		
		
		label.text = str(int(energy))

		#print(energy)
		move_and_slide()
		if Input.is_action_just_pressed("Jump") and terreno=="entrada_vacio":
			print ("trying to move")
			canMove= false
			
			
	
	#else:
	#	var direcion= (destiny-global_position).normalized()
	#	var distancia=global_position.distance_to(destiny)
	#	if distancia> 1:
	#		velocity=direcion*SPEED
	#aca poner como se movería el bichurraco coso que no se como hacerlo todavia :3
>>>>>>> Stashed changes


func _on_timer_timeout() -> void:
	if !canDash:
		canDash = true
<<<<<<< Updated upstream
=======

"""
func _on_area_2d_area_entered(area: Area2D) -> void:

	print(area.name)
	if area.name=="Hielo":
		DASH_MULTIPLIER=10
		print("estoy tocando hielo")
	if area.name=="pegajoso":
		DASH_MULTIPLIER=2
		print("estoy tocando pegajoso")
	if area.name=="Vacio":
		print("estoy en el vacio")
		canMove=false
		#opcion para que le aparezca el coso ese de oprimir el boton
		if Input.is_action_just_pressed("Jump"):
			auto_move=true
			
	if area.name=="Area_de_llegada":
		print("estoy en el area de llegada")
		canMove=true"""
func _on_area_2d_area_exited(area: Area2D) -> void:
	DASH_MULTIPLIER=4
	
func change_terreno(tipo, area):
	terreno=tipo
	print(terreno)
	if terreno=="vacio":
		Caer()
		print("estoy tocando vacio")
	elif terreno=="entrada_vacio":
		destiny = area.destiny
		print("estoy entrando/saliendo vacio")
		#habilitar el usar el e
	elif terreno=="hielo":
		DASH_MULTIPLIER=10
		print("estoy tocando hielo")
	elif terreno=="pegajoso":
		print("estoy tocando pegajoso")
		DASH_MULTIPLIER=2
>>>>>>> Stashed changes
