#HuntArlithons
extends MynraState

@export var mynra: PlayerMynra
@export var mynra_animation: AnimatedSprite2D

var arlithon: CharacterBody2D		#tracks the current target arlithon
var arlithons						#Scans current scene to check for any arlithons currently in it
var one_still_lives: bool = true

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	arlithons = get_tree().get_nodes_in_group("Arlithons")
	
	# Immediately check if the current target is no longer alive
	if mynra.target_arlithon and !mynra.target_arlithon.is_alive:
		mynra.target_arlithon = null  # Clear the target reference if needed
		_hunt_arlithons()               # Find a new target if possible
	
	if _are_they_all_dead():
		one_still_lives = false
	
	var check_for_target: int = 0
	
	for body in arlithons:
		# If body is alive and is the current target, move toward it.
		if mynra.is_alive and body == mynra.target_arlithon:
			var direction = mynra.to_local(mynra.nav.get_next_path_position()).normalized()
			mynra.velocity = direction * mynra.speed
			
			# Play the proper animation based on movement direction
			if abs(direction.x) > abs(direction.y):
				if direction.x > 0:
					mynra_animation.play("Run_R")
				else:
					mynra_animation.play("Run_L")
			else:
				if direction.y > 0:
					mynra_animation.play("Run_D")
				else:
					mynra_animation.play("Run_U")
		
		# If the body is the target but no longer alive, hunt for a new target.
		elif body == mynra.target_arlithon and !body.is_alive:
			_hunt_arlithons()
		
		# Otherwise, count up to decide if no valid target remains.
		elif body != mynra.target_arlithon:
			check_for_target += 1
			if check_for_target >= arlithons.size():
				_hunt_arlithons()

func _hunt_arlithons():
	if one_still_lives:
		for body in arlithons:
			if !body.is_mutated && body.is_alive:
				mynra.target_arlithon = body
				#print("Following arlithon: ", body)
			elif body.is_targeted_by_player && body.is_alive:
				mynra.target_arlithon = body

func _on_target_death():
	mynra.target_arlithon.is_alive = false
	_hunt_arlithons()

func _are_they_all_dead() -> bool:
	for node in arlithons:
		if node.is_alive:
			return false
	return true

func _make_path():
	if mynra.target_arlithon:
		mynra.nav.target_position = mynra.target_arlithon.global_position
	else:
		transition.emit("Idle")

func _on_nav_timeout() -> void:
	_make_path()

#Handles transitioning between states
func _on_next_transitions() -> void:
	
	if !mynra.player:
		var distance
		
		var too_close: bool = false
		arlithons = get_tree().get_nodes_in_group("Arlithons")
		
		for body in arlithons:
			if body.global_position.distance_to(mynra.global_position) < 50:
				too_close = true
		
		if mynra.target_arlithon:
			distance = mynra.target_arlithon.global_position.distance_to(mynra.global_position)
		else:
			distance = 0
		
		if arlithons.is_empty() || !one_still_lives:
			transition.emit("FollowPlayer")
		elif (mynra.arlithon_in_prim_atk_range || distance <= 25) && mynra.target_arlithon.is_alive:
			transition.emit("PrimaryAttack")
		elif mynra.arlithon_in_sec_atk_range && mynra.target_arlithon.is_alive && mynra.ammo > 0 && !mynra.arlithon_in_prim_atk_range && !mynra.sec_atk_cooldown && !too_close:
			transition.emit("SecondaryAttack")
		elif (mynra.at_player) && (arlithons.is_empty() || !one_still_lives):
			transition.emit("Idle")
	else:
		transition.emit("Idle")
	

#Runs upon entering state
func _on_enter():
	arlithons = get_tree().get_nodes_in_group("Arlithons")
	for body in arlithons:
		body.dead.connect(_on_target_death)
	
	_make_path()

#Runs upon exiting state
func _on_exit():
	pass
