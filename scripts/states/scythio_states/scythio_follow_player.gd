#FollowPlayerState
extends ScythioState

@export var scythio: PlayerScythio
@export var scythio_animation: AnimatedSprite2D

#Scans current scene to check for any arlithons currently in it
var arlithons
var eligible_targets

#tracks current player character for following between levels
var player_character : CharacterBody2D

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	eligible_targets = 0
	arlithons = get_tree().get_nodes_in_group("Arlithons")
	
	for body in arlithons:
		if body.is_alive && !body.is_mutated:
			eligible_targets += 1
		elif body.is_alive && body.is_targeted_by_player:
			eligible_targets += 1
	
	#Checks to make sure there are no arlithons left to be attacked, then, if not, follows the player
	#if arlithons.is_empty():
	var direction = scythio.to_local(scythio.nav.get_next_path_position()).normalized()
	
	scythio.velocity = direction.normalized() * scythio.speed
	
	#Used for playing the proper animation depending on what direction Scythio is moving (Right, Left, Down, or Up)
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			scythio_animation.play("Run_R")
		else:
			scythio_animation.play("Run_L")
	else:
		if direction.y > 0:
			scythio_animation.play("Run_D")
		else:
			scythio_animation.play("Run_U")

func _make_path():
	scythio.nav.target_position = scythio.player_body.global_position
	
func _on_nav_timeout() -> void:
	_make_path()

#Handles transitioning between states
func _on_next_transitions() -> void:
	if !scythio.player:
		if eligible_targets > 0:
			transition.emit("HuntArlithons")
		elif scythio.at_player:
			transition.emit("Idle")
		elif scythio.global_position.distance_to(scythio.player_body.global_position) >= 120:
			transition.emit("Dash")
	else:
		transition.emit("Idle")

#Runs upon entering state
func _on_enter():
	_make_path()

#Runs upon exiting state
func _on_exit():
	pass
