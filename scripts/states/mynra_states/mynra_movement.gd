#MynraMovement
extends MynraState

#Exports Mynra and her animation node
@export var mynra: PlayerMynra
@export var mynra_animation: AnimatedSprite2D

#Runs each frame
func _on_physics_update(_delta: float) -> void:
	#Gets player input from the "Game_Input_Events" class
	var direction: Vector2 = Game_Input_Events.movement_input()					#Used to determine animation direction (cardinal)
	var input_velocity: Vector2 = Game_Input_Events.velocity_of_movement()		#Used to determine movement velocity (8-directional)
	
	#Plays the appropriate animation based on the player's current movement direction
	if direction == Vector2.LEFT: mynra_animation.play("Run_L")
	elif direction == Vector2.RIGHT: mynra_animation.play("Run_R")
	elif direction == Vector2.UP: mynra_animation.play("Run_U")
	elif direction == Vector2.DOWN: mynra_animation.play("Run_D")
	
	#Tracks current movement direction and stores it so that other
	#states (such as idle) animate properly when they are switched to
	if direction != Vector2.ZERO:
		mynra.player_direction = direction
	
	#Handles actual player movement
	mynra.velocity = input_velocity * mynra.speed
	mynra.move_and_slide()

#Handles transitioning between states
func _on_next_transitions() -> void:
	
	if mynra.damaged:
		transition.emit("Damaged")
	else:
		if Game_Input_Events.is_sec_attacking():
			transition.emit("Secondary_Attack")
		elif Game_Input_Events.is_prim_attacking():
			transition.emit("Primary_Attack")
		elif !Game_Input_Events.is_movement_input():
			transition.emit("Idle")
		elif Game_Input_Events.is_dashing() && mynra.get_parent().name != "Oblivion":
			transition.emit("Dash")

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	mynra_animation.stop()
