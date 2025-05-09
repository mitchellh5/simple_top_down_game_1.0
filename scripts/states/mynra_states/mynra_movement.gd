#MovementState
extends MynraState

@export var scythio: PlayerScythio
@export var scythio_animation : AnimatedSprite2D

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	#Gets player input from the "Game_Input_Events" class
	if scythio.player:
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
	else:
		transition.emit("Idle")

#Handles transitioning between states
func _on_next_transitions() -> void:
	#Gets movement input from "Game_Input_Events" class
	#to allow the state to detect movement and change
	#states appropriately based on that
	#NOTE: For some reason, this is only necessary in the idle state
	#and if you remove it from the idle state the machine breaks, so don't
	#do that
	Game_Input_Events.movement_input()
	
	if scythio.damaged:
		transition.emit("Damaged")
	else:
		if Game_Input_Events.is_sec_attacking():
			transition.emit("SecondaryAttack")
		elif Game_Input_Events.is_prim_attacking():
			transition.emit("PrimaryAttack")
		elif !Game_Input_Events.is_movement_input():
			transition.emit("Idle")
		elif Game_Input_Events.is_dashing() && scythio.get_parent().name != "Oblivion":
			transition.emit("Dash")

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	pass
