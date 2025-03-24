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
	
	# Immediately check if the current target is no longer alive
	if scythio.target_arlithon and !scythio.target_arlithon.is_alive:
		scythio.target_arlithon = null  # Clear the target reference if needed
		_hunt_arlithons()               # Find a new target if possible
	
	if _are_they_all_dead():
		one_still_lives = false
	
	var check_for_target: int = 0
	
	for body in arlithons:
		# If body is alive and is the current target, move toward it.
		if body.is_alive and body == scythio.target_arlithon:
			var direction: Vector2 = scythio.target_arlithon.global_position - scythio.global_position
			var normalized_direction = direction.normalized()
			scythio.velocity = normalized_direction * scythio.speed
			
			# Play the proper animation based on movement direction
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
		
		# If the body is the target but no longer alive, hunt for a new target.
		elif body == scythio.target_arlithon and !body.is_alive:
			_hunt_arlithons()
		
		# Otherwise, count up to decide if no valid target remains.
		elif body != scythio.target_arlithon:
			check_for_target += 1
			if check_for_target >= arlithons.size():
				_hunt_arlithons()

func _hunt_arlithons():
	if one_still_lives:
		for body in arlithons:
			if !body.is_mutated && body.is_alive:
				scythio.target_arlithon = body
				#print("Following arlithon: ", body)
			elif body.is_targeted_by_player && body.is_alive:
				scythio.target_arlithon = body

func _on_target_death():
	scythio.target_arlithon.is_alive == false
	_hunt_arlithons()

func _are_they_all_dead() -> bool:
	for node in arlithons:
		if node.is_alive:
			return false
	return true

#Handles transitioning between states
func _on_next_transitions() -> void:
	
	if arlithons.is_empty() || !one_still_lives || scythio.target_arlithon == $"<Freed Object>":
		transition.emit("FollowPlayer")
	elif scythio.arlithon_in_prim_atk_range && scythio.target_arlithon.is_alive:
		transition.emit("PrimaryAttack")
	elif (scythio.at_player) && (arlithons.is_empty() || !one_still_lives):
		transition.emit("Idle")
	

#Runs upon entering state
func _on_enter():
	arlithons = get_tree().get_nodes_in_group("Arlithons")
	for body in arlithons:
		body.dead.connect(_on_target_death)

#Runs upon exiting state
func _on_exit():
	pass
