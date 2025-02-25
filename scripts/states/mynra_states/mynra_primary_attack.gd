#MynraPrimaryAttack
extends MynraState

#Exports Mynra and her animation node
@export var player: PlayerMynra
@export var player_animation: AnimatedSprite2D

var is_animating: bool = false
var atk_vel: Vector2 = Vector2.ZERO

#Runs every frame
func _on_update(_delta: float) -> void:
	player_animation.animation_finished.connect(_on_animation_finished)

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	if Input.is_action_pressed("primary_attack"):
		primary_attack()
	
	if is_animating:
		#Gets input velocity from the "Game_Input_Events" class,
		#and uses it to calculate the proper direction of the dash
		var input_velocity: Vector2 = Game_Input_Events.velocity_of_movement()
		player.velocity = atk_vel
		player.move_and_slide()

#Handles primary attack
func primary_attack():
	#Makes sure the player is not currently animating to avoid overlapping animations
	if !is_animating:
		is_animating = true
		
		var input_velocity = Game_Input_Events.velocity_of_movement()					#Gets player's current velocity_vector from the "Game_Input_Events" class
		if input_velocity != Vector2.ZERO:												#As long as the velocity vector is not 0, it will set the player to dash
			atk_vel = input_velocity.normalized() * player.speed * 0.25			#in the current direction of movement.
		else:																			#Otherwise, it dashes in the direction the player is currently facing
			atk_vel = player.player_direction.normalized() * player.speed * 0.25	#(for cases where the player dashes from an idle position)
		
		#------------------------------------------------------------------------------------
		#
		#Summary: Plays primary attack animation based on player direction.
		#
		#
		#If the player is using a controller, it will choose to determine animation direction
		#based on the direction the player is currently facing (cardinal). Otherwise, it will
		#determine it from the position of the mouse cursor.
		#Once a direction for the attack has been determined, it will play that animation and
		#rotate the "atk_area" Area2D mask to face that direction. Once the mask is correctly
		#oriented, it will run "get_overlapping_bodies()" to detect any bodies with the
		#method "take_damage" and run it for each of them. This is how the primary attack will
		#deal damage to enemies in its range.
		#
		#------------------------------------------------------------------------------------
		if Input.get_connected_joypads().size() > 0:
			if player.player_direction == Vector2.LEFT:
				player_animation.play("Prim_Atk1_L")
				player.atk_area.rotation_degrees = 0
				var bodies = player.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
			elif player.player_direction == Vector2.RIGHT:
				player_animation.play("Prim_Atk1_R")
				player.atk_area.rotation_degrees = 180
				var bodies = player.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
			elif player.player_direction == Vector2.DOWN:
				player_animation.play("Prim_Atk1_D")
				player.atk_area.rotation_degrees = -90
				var bodies = player.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
			else:
				player_animation.play("Prim_Atk1_U")
				player.atk_area.rotation_degrees = 90
				var bodies = player.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
		
		else:
			if player.angle >= -45 && player.angle < 45:
				player_animation.play("Prim_Atk1_R")
				player.atk_area.rotation_degrees = 180
				var bodies = player.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
		
			elif player.angle >= 45 && player.angle < 135:
				player_animation.play("Prim_Atk1_D")
				player.atk_area.rotation_degrees = -90
				var bodies = player.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
		
			elif player.angle >= -135 && player.angle < -45:
				player_animation.play("Prim_Atk1_U")
				player.atk_area.rotation_degrees = 90
				var bodies = player.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
			else:
				player_animation.play("Prim_Atk1_L")
				player.atk_area.rotation_degrees = 0
				var bodies = player.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()

#Handles transitioning between states
func _on_next_transitions() -> void:
	if is_animating:
		return
	
	if player.damaged:
		transition.emit("Damaged")
	else:
		if Game_Input_Events.is_movement_input():
			transition.emit("Movement")
		elif Game_Input_Events.is_sec_attacking():
			transition.emit("Secondary_Attack")
		elif Game_Input_Events.is_dashing():
			transition.emit("Dash")
		elif !Game_Input_Events.is_movement_input():
			transition.emit("Idle")

#Tracks when animation is finished
func _on_animation_finished():
	if player_animation.animation in ["Prim_Atk1_R", "Prim_Atk1_L", "Prim_Atk1_U", "Prim_Atk1_D"]:
		is_animating = false

#Runs upon entering state
func _on_enter():
	is_animating = false

#Runs upon exiting state
func _on_exit():
	is_animating = false
