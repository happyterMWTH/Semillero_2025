extends CharacterBody2D
class_name Player
#@onready var detector=preload("res:Dectector.gd").new()


@export_group("Movimiento Básico")
@export var SPEED = 300.0
@export var ACCEL = 12 

@export_group("Dash")
@export var DashCooldown: Timer 
@export var DASH_MULTIPLIER = 4
@export var MAX_ENERGY = 100
@export var ENERGY_PER_DASH = 10
@export var energy: float = MAX_ENERGY

@export_group("Animation")
@export var tree: AnimationTree 

@export_group("Test Stuff")
@export var label: RichTextLabel
var canDash: bool = true
var state_machine: AnimationNodeStateMachinePlayback

func _ready() -> void:
	state_machine = tree["parameters/playback"]
	


func get_input() -> Vector2:
	var x := Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var y := Input.get_action_strength("Down") - Input.get_action_strength("Up")
	return Vector2(x,y)


func dash(direction: Vector2) -> void:
	velocity = DASH_MULTIPLIER * SPEED * direction


func _physics_process(delta: float) -> void:
	var playerInput := get_input()
	
	# Find which direction is bigger and lock it there
	if abs(playerInput.x) >= abs(playerInput.y):
		playerInput.y =0
		
	else:
		playerInput.x = 0
	
	if playerInput.x != 0 or playerInput.y != 0:
		
		tree.set("parameters/conditions/walk", true)
		tree.set("parameters/conditions/idle", false)
	else:
		tree.set("parameters/conditions/idle", true)
		
		tree.set("parameters/conditions/walk", false)
		
	
	tree.set("parameters/Walk/Animaciones/blend_position", playerInput)
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


func _on_timer_timeout() -> void:
	if !canDash:
		canDash = true


func _on_area_2d_area_entered(area: Area2D) -> void:

	print(area.name)
	if area.name=="Hielo":
		DASH_MULTIPLIER=10
		print("estoy tocando hielo")
	if area.name=="pegajoso":
		DASH_MULTIPLIER=2
		print("estoy tocando pegajoso")


func _on_area_2d_area_exited(area: Area2D) -> void:
	DASH_MULTIPLIER=4
