extends CharacterBody2D
class_name Player


@export_group("Movimiento Básico")
@export var SPEED = 300.0
@export var ACCEL = 25

@export_group("Dash")
@export var DashCooldown: Timer 
@export var DASH_SPEED =20
@export var MAX_ENERGY = 100
@export var ENERGY_PER_DASH = 10
@export var energy: float = MAX_ENERGY


@export_group("Test Stuff")
@export var label: RichTextLabel
var canDash: bool = true

	


func get_input() -> Vector2:
	var x := Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var y := Input.get_action_strength("Down") - Input.get_action_strength("Up")
	return Vector2(x,y)


func dash() -> void:
	velocity = velocity * DASH_SPEED


func _physics_process(delta: float) -> void:
	
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
		dash()

	if energy < MAX_ENERGY:
		energy += (log(energy) / log(1.5) + 1) * delta 
		energy = clamp(energy, 1, MAX_ENERGY)	


	label.text = str(int(energy))

	print(energy)
	move_and_slide()


func _on_timer_timeout() -> void:
	if !canDash:
		canDash = true
