#FollowPlayerState
extends ScythioState

@export var scythio : PlayerScythio
@export var scythio_animation : AnimatedSprite2D

#Scans current scene to check for any arlithons currently in it
var arlithons

#tracks current player character for following between levels
var player_character : CharacterBody2D 

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	arlithons = get_tree().get_nodes_in_group("Arlithons")
	#Checks to make sure there are no arlithons left to be attacked, then, if not, follows the player
	if arlithons.is_empty():
		var direction: Vector2 = scythio.player_body.global_position - scythio.global_position
		var normalized_direction = direction.normalized()
		
		scythio.velocity = direction.normalized() * scythio.speed
		
		#Used for playing the proper animation depending on what direction Scythio is moving (Right, Left, Down, or Up)
		if abs(normalized_direction.x) > abs(normalized_direction.y):
			if normalized_direction.x > 0:
				scythio_animation.play("Run_R")
			else:
				scythio_animation.play("Run_L")
		else:
			if normalized_direction.y > 0:
				scythio_animation.play("Run_D")
			else:
				scythio_animation.play("Run_U")

#Handles transitioning between states
func _on_next_transitions() -> void:
	if scythio.at_player:
		transition.emit("Idle")
	elif !arlithons.is_empty():
		transition.emit("HuntArlithons")

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	pass
