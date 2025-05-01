#MynraIdle
extends MynraState

#Exports Mynra and her animation node
@export var mynra: CharacterBody2D
@export var mynra_animation: AnimatedSprite2D

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	#Plays the proper animation based on the direction the player was facing
	#when they entered the state (NOTE: there are no "Idle_U" animations)
	if mynra.player_direction == Vector2.LEFT: mynra_animation.play("Idle_L")
	elif mynra.player_direction == Vector2.RIGHT: mynra_animation.play("Idle_R")
	else: mynra_animation.play("Idle1_D")

#Handles transitions between scene
func _on_next_transitions() -> void:
	#Gets movement input from "Game_Input_Events" class
	#to allow the state to detect movement and change
	#states appropriately based on that
	#NOTE: For some reason, this is only necessary in the idle state
	#and if you remove it from the idle state the machine breaks, so don't
	#do that
	Game_Input_Events.movement_input()
	
	if mynra.damaged:
		transition.emit("Damaged")
	elif !GlobalState.input_paused:
		if Game_Input_Events.is_movement_input():
			transition.emit("Movement")
		elif Game_Input_Events.is_dashing() && mynra.get_parent().name != "Oblivion":
			transition.emit("Dash")
		elif Game_Input_Events.is_prim_attacking():
			transition.emit("Primary_Attack")
		elif Game_Input_Events.is_sec_attacking():
			transition.emit("Secondary_Attack")

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	mynra_animation.stop()
