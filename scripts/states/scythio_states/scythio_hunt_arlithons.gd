#HuntArlithons
extends ScythioState

@export var scythio : PlayerScythio
@export var scythio_animation : AnimatedSprite2D

var arlithon : CharacterBody2D		#tracks the current target arlithon
var arlithons						#Scans current scene to check for any arlithons currently in it
var one_still_lives : bool = true

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	arlithons = get_tree().get_nodes_in_group("Arlithons")
	
	if _are_they_all_dead() == true:
		one_still_lives = false
	elif one_still_lives:
		for body in arlithons:
			if !body.is_mutated && body.is_alive:
				scythio.target_arlithon = body
				#print("Following arlithon: ", body)
				
				var direction : Vector2 = body.global_position - scythio.global_position
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
				
			elif body.is_targeted_by_player && body.is_alive:
				scythio.target_arlithon = body
				#print("Assisting player with arlithon: ", body)
				var direction : Vector2 = body.global_position - scythio.global_position
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

func _are_they_all_dead() -> bool:
	for node in arlithons:
		if node.is_alive:
			return false
	return true

#Handles transitioning between states
func _on_next_transitions() -> void:
	
	if (arlithons.is_empty() || !one_still_lives) && (!scythio.at_player):
		transition.emit("FollowPlayer")
	elif scythio.arlithon_in_prim_atk_range:
		transition.emit("PrimaryAttack")
	elif (scythio.at_player) && (arlithons.is_empty() || !one_still_lives):
		transition.emit("Idle")
	

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	pass
