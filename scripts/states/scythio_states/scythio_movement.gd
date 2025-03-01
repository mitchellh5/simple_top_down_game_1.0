#MovementState
extends ScythioState

@export var scythio : PlayerScythio
@export var scythio_animation : AnimatedSprite2D

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	#Gets player input from the "Game_Input_Events" class
	var direction: Vector2 = Game_Input_Events.movement_input()					#Used to determine animation direction (cardinal)
	var input_velocity: Vector2 = Game_Input_Events.velocity_of_movement()		#Used to determine movement velocity (8-directional)
	
	#Plays the appropriate animation based on the player's current movement direction
	if direction == Vector2.LEFT: scythio_animation.play("Run_L")
	elif direction == Vector2.RIGHT: scythio_animation.play("Run_R")
	elif direction == Vector2.UP: scythio_animation.play("Run_U")
	elif direction == Vector2.DOWN: scythio_animation.play("Run_D")
	
	#Tracks current movement direction and stores it so that other
	#states (such as idle) animate properly when they are switched to
	if direction != Vector2.ZERO:
		scythio.player_direction = direction
	
	#Handles actual player movement
	scythio.velocity = input_velocity * scythio.speed
	scythio.move_and_slide()

#Handles transitioning between states
func _on_next_transitions() -> void:
	pass

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	pass
