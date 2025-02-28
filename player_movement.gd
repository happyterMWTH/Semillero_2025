extends CharacterBody2D
class_name Player

@export var SPEED = 300.0
@export var ACCEL = 25
@export var DashCooldown: Timer 

var canDash: bool = true

	
func get_input() -> Vector2:
	var x := Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var y := Input.get_action_strength("Down") - Input.get_action_strength("Up")
	return Vector2(x,y).normalized()


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


func _on_timer_timeout() -> void:
	if !canDash:
		canDash = true
