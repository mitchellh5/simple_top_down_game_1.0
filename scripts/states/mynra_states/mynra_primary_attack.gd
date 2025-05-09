#PrimaryAttack
extends MynraState

@export var mynra: PlayerMynra
@export var mynra_animation: AnimatedSprite2D

var arlithons

var is_animating: bool = false
var atk_on_cooldown: bool = false
var atk_vel: Vector2 = Vector2.ZERO

func _ready() -> void:
	#Tracks if animation has finished, and when it has, it runs the "_on_animation_finished()" function
	mynra_animation.animation_finished.connect(_on_animation_finished)

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	arlithons = get_tree().get_nodes_in_group("Arlithons")
	
	if mynra.player && Input.is_action_pressed("primary_attack"):
		primary_attack_player()
	elif !mynra.player && mynra.arlithon_in_prim_atk_range:
		primary_attack_companion()
		
	
	if mynra.player && is_animating:
		#Gets input velocity from the "Game_Input_Events" class,
		#and uses it to calculate the proper direction of the dash
		var input_velocity: Vector2 = Game_Input_Events.velocity_of_movement()
		mynra.velocity = atk_vel
		mynra.move_and_slide()

func primary_attack_player():
	#Makes sure the player is not currently animating to avoid overlapping animations
	if !is_animating:
		is_animating = true
		
		var input_velocity = Game_Input_Events.velocity_of_movement()					#Gets player's current velocity_vector from the "Game_Input_Events" class
		if input_velocity != Vector2.ZERO:												#As long as the velocity vector is not 0, it will set the player to dash
			atk_vel = input_velocity.normalized() * mynra.speed * 0.25			#in the current direction of movement.
		else:																			#Otherwise, it dashes in the direction the player is currently facing
			atk_vel = mynra.player_direction.normalized() * mynra.speed * 0.25	#(for cases where the player dashes from an idle position)
		
		#------------------------------------------------------------------------------------
		#
		#Summary: Plays primary attack animation based on player direction.
		#
		#
		#If the player is using a controller, it will choose to determine animation direction
		#based on the direction the player is currently facing (cardinal). Otherwise, it will
		#determine it from the position of the mouse cursor.
		#Once a direction for the attack has been determined, it will play that animation and
		#rotate the "hit_box" Area2D mask to face that direction. Once the mask is correctly
		#oriented, it will run "get_overlapping_bodies()" to detect any bodies with the
		#method "take_damage" and run it for each of them. This is how the primary attack will
		#deal damage to enemies in its range.
		#
		#------------------------------------------------------------------------------------
		if Input.get_connected_joypads().size() > 0:
			if mynra.player_direction == Vector2.LEFT:
				mynra_animation.play("Prim_Atk1_L")
				mynra.hit_box.rotation_degrees = 0
				var bodies = mynra.hit_box.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
			elif mynra.player_direction == Vector2.RIGHT:
				mynra_animation.play("Prim_Atk1_R")
				mynra.hit_box.rotation_degrees = 180
				var bodies = mynra.hit_box.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
			elif mynra.player_direction == Vector2.DOWN:
				mynra_animation.play("Prim_Atk1_D")
				mynra.hit_box.rotation_degrees = -90
				var bodies = mynra.hit_box.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
			else:
				mynra_animation.play("Prim_Atk1_U")
				mynra.hit_box.rotation_degrees = 90
				var bodies = mynra.hit_box.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
		
		else:
			if mynra.angle >= -45 && mynra.angle < 45:
				mynra_animation.play("Prim_Atk1_R")
				mynra.hit_box.rotation_degrees = 180
				var bodies = mynra.hit_box.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
		
			elif mynra.angle >= 45 && mynra.angle < 135:
				mynra_animation.play("Prim_Atk1_D")
				mynra.hit_box.rotation_degrees = -90
				var bodies = mynra.hit_box.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
		
			elif mynra.angle >= -135 && mynra.angle < -45:
				mynra_animation.play("Prim_Atk1_U")
				mynra.hit_box.rotation_degrees = 90
				var bodies = mynra.hit_box.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
			else:
				mynra_animation.play("Prim_Atk1_L")
				mynra.hit_box.rotation_degrees = 0
				var bodies = mynra.hit_box.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()

func primary_attack_companion():
	if !is_animating && mynra.target_arlithon.is_alive && !atk_on_cooldown && mynra.arlithon_in_prim_atk_range:
		is_animating = true
		atk_on_cooldown = true
		mynra.atk_cooldown_timer.start()
		
		
		var input_velocity = mynra.target_arlithon.global_position - mynra.global_position	#Gets the direction Mynra is currently attacking in
		
		var direction = mynra.target_arlithon.global_position - mynra.global_position
		var abs_x = abs(direction.x)
		var abs_y = abs(direction.y)
		
		var bodies = mynra.hit_box.get_overlapping_bodies()
		
		mynra.velocity = Vector2.ZERO
		
		if abs_x > abs_y:
			if direction.x > 0:
				mynra.hit_box.rotation_degrees = 180
				mynra_animation.play("Prim_Atk1_R")
			else:
				mynra.hit_box.rotation_degrees = 0
				mynra_animation.play("Prim_Atk1_L")
		else:
			if direction.y > 0:
				mynra.hit_box.rotation_degrees = -90
				mynra_animation.play("Prim_Atk1_D")
			else:
				mynra.hit_box.rotation_degrees = 90
				mynra_animation.play("Prim_Atk1_U")
		
		for body in bodies:
			if body.has_method("take_damage"):
				body.take_damage()

func _on_prim_atk_cooldown_timeout() -> void:
	atk_on_cooldown = false

#Handles transitioning between states
func _on_next_transitions() -> void:
	if is_animating:
		return
	
	if mynra.damaged:
		transition.emit("Damaged")
	elif mynra.player:
		if Game_Input_Events.is_movement_input():
			transition.emit("Movement")
		elif Game_Input_Events.is_sec_attacking():
			transition.emit("SecondaryAttack")
		elif Game_Input_Events.is_dashing():
			transition.emit("Dash")
		elif !Game_Input_Events.is_movement_input():
			transition.emit("Idle")
	else:
		if arlithons.is_empty() && !mynra.at_player:
			transition.emit("FollowPlayer")
			#print("Tried to transition to FP")
		elif !arlithons.is_empty() && !mynra.target_arlithon.is_alive:
			transition.emit("HuntArlithons")
			#print("Tried to transition to HA 1")
		elif !arlithons.is_empty() && !mynra.arlithon_in_prim_atk_range:
			transition.emit("HuntArlithons")
			#print("Tried to transition to HA 2")

#Tracks when animation is finished
func _on_animation_finished():
	if mynra_animation.animation in ["Prim_Atk1_R", "Prim_Atk1_L", "Prim_Atk1_U", "Prim_Atk1_D"]:
		is_animating = false

#Runs upon entering state
func _on_enter():
	print("I'm attacking now")
	is_animating = false

#Runs upon exiting state
func _on_exit():
	is_animating = false
	#mynra_animation.stop()
