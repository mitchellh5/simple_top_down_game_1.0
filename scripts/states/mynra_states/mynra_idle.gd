#MynraIdle
extends MynraState

#Exports Mynra and her animation node
@export var player: CharacterBody2D
@export var player_animation: AnimatedSprite2D

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	#Plays the proper animation based on the direction the player was facing
	#when they entered the state (NOTE: there are no "Idle_U" animations)
	if player.player_direction == Vector2.LEFT: player_animation.play("Idle_L")
	elif player.player_direction == Vector2.RIGHT: player_animation.play("Idle_R")
	else: player_animation.play("Idle1_D")

#Handles transitions between scene
func _on_next_transitions() -> void:
	#Gets movement input from "Game_Input_Events" class
	#to allow the state to detect movement and change
	#states appropriately based on that
	#NOTE: For some reason, this is only necessary in the idle state
	#and if you remove it from the idle state the machine breaks, so don't
	#do that
	Game_Input_Events.movement_input()
	
	if player.damaged:
		transition.emit("Damaged")
	else:
		if Game_Input_Events.is_movement_input():
			transition.emit("Movement")
		elif Game_Input_Events.is_dashing():
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
	player_animation.stop()
