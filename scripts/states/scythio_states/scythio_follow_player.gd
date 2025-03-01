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
	arlithons = get_tree().get_nodes_in_group("arlithons")
	#Checks to make sure there are no arlithons left to be attacked, then, if not, follows the player
	if arlithons.is_empty():
		var direction = scythio.player_body.global_position - scythio.global_position
		
		scythio.velocity = direction.normalized() * scythio.speed

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
