#PrimaryAttack
extends MynraState

@export var scythio: PlayerScythio
@export var scythio_animation: AnimatedSprite2D

var arlithons

var is_animating: bool = false
var atk_on_cooldown: bool = false
var atk_vel: Vector2 = Vector2.ZERO

func _ready() -> void:
	#Tracks if animation has finished, and when it has, it runs the "_on_animation_finished()" function
	scythio_animation.animation_finished.connect(_on_animation_finished)

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	arlithons = get_tree().get_nodes_in_group("Arlithons")
	
	if scythio.player && Input.is_action_pressed("primary_attack"):
		primary_attack_player()
	elif !scythio.player && scythio.arlithon_in_prim_atk_range:
		primary_attack_companion()
		
	
	if scythio.player && is_animating:
		#Gets input velocity from the "Game_Input_Events" class,
		#and uses it to calculate the proper direction of the dash
		var input_velocity: Vector2 = Game_Input_Events.velocity_of_movement()
		scythio.velocity = atk_vel
		scythio.move_and_slide()

func primary_attack_player():
	#Makes sure the player is not currently animating to avoid overlapping animations
	if !is_animating:
		is_animating = true
		
		var input_velocity = Game_Input_Events.velocity_of_movement()					#Gets player's current velocity_vector from the "Game_Input_Events" class
		if input_velocity != Vector2.ZERO:												#As long as the velocity vector is not 0, it will set the player to dash
			atk_vel = input_velocity.normalized() * scythio.speed * 0.25			#in the current direction of movement.
		else:																			#Otherwise, it dashes in the direction the player is currently facing
			atk_vel = scythio.player_direction.normalized() * scythio.speed * 0.25	#(for cases where the player dashes from an idle position)
		
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
			if scythio.player_direction == Vector2.LEFT:
				scythio_animation.play("Prim_Atk1_L")
				scythio.atk_area.rotation_degrees = 0
				var bodies = scythio.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
			elif scythio.player_direction == Vector2.RIGHT:
				scythio_animation.play("Prim_Atk1_R")
				scythio.atk_area.rotation_degrees = 180
				var bodies = scythio.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
			elif scythio.player_direction == Vector2.DOWN:
				scythio_animation.play("Prim_Atk1_D")
				scythio.atk_area.rotation_degrees = -90
				var bodies = scythio.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
			else:
				scythio_animation.play("Prim_Atk1_U")
				scythio.atk_area.rotation_degrees = 90
				var bodies = scythio.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
		
		else:
			if scythio.angle >= -45 && scythio.angle < 45:
				scythio_animation.play("Prim_Atk1_R")
				scythio.atk_area.rotation_degrees = 180
				var bodies = scythio.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
		
			elif scythio.angle >= 45 && scythio.angle < 135:
				scythio_animation.play("Prim_Atk1_D")
				scythio.atk_area.rotation_degrees = -90
				var bodies = scythio.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
		
			elif scythio.angle >= -135 && scythio.angle < -45:
				scythio_animation.play("Prim_Atk1_U")
				scythio.atk_area.rotation_degrees = 90
				var bodies = scythio.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()
			else:
				scythio_animation.play("Prim_Atk1_L")
				scythio.atk_area.rotation_degrees = 0
				var bodies = scythio.atk_area.get_overlapping_bodies()
				for body in bodies:
					if body.has_method("take_damage"):
						body.take_damage()

func primary_attack_companion():
	if !is_animating && scythio.target_arlithon.is_alive && !atk_on_cooldown && scythio.arlithon_in_prim_atk_range:
		is_animating = true
		atk_on_cooldown = true
		scythio.atk_cooldown_timer.start()
		
		
		var input_velocity = scythio.target_arlithon.global_position - scythio.global_position	#Gets the direction scythio is currently attacking in
		
		var direction = scythio.target_arlithon.global_position - scythio.global_position
		var abs_x = abs(direction.x)
		var abs_y = abs(direction.y)
		
		var bodies = scythio.atk_area.get_overlapping_bodies()
		
		scythio.velocity = Vector2.ZERO
		
		if abs_x > abs_y:
			if direction.x > 0:
				scythio.atk_area.rotation_degrees = 180
				scythio_animation.play("Prim_Atk1_R")
			else:
				scythio.atk_area.rotation_degrees = 0
				scythio_animation.play("Prim_Atk1_L")
		else:
			if direction.y > 0:
				scythio.atk_area.rotation_degrees = -90
				scythio_animation.play("Prim_Atk1_D")
			else:
				scythio.atk_area.rotation_degrees = 90
				scythio_animation.play("Prim_Atk1_U")
		
		for body in bodies:
			if body.has_method("take_damage"):
				body.take_damage()

func _on_prim_atk_cooldown_timeout() -> void:
	atk_on_cooldown = false

#Handles transitioning between states
func _on_next_transitions() -> void:
	if is_animating:
		return
	
	if scythio.damaged:
		transition.emit("Damaged")
	elif scythio.player:
		if Game_Input_Events.is_movement_input():
			transition.emit("Movement")
		elif Game_Input_Events.is_sec_attacking():
			transition.emit("SecondaryAttack")
		elif Game_Input_Events.is_dashing():
			transition.emit("Dash")
		elif !Game_Input_Events.is_movement_input():
			transition.emit("Idle")
	else:
		if arlithons.is_empty() && !scythio.at_player:
			transition.emit("FollowPlayer")
			#print("Tried to transition to FP")
		elif !arlithons.is_empty() && !scythio.target_arlithon.is_alive:
			transition.emit("HuntArlithons")
			#print("Tried to transition to HA 1")
		elif !arlithons.is_empty() && !scythio.arlithon_in_prim_atk_range:
			transition.emit("HuntArlithons")
			#print("Tried to transition to HA 2")

#Tracks when animation is finished
func _on_animation_finished():
	if scythio_animation.animation in ["Prim_Atk1_R", "Prim_Atk1_L", "Prim_Atk1_U", "Prim_Atk1_D"]:
		is_animating = false

#Runs upon entering state
func _on_enter():
	print("I'm attacking now")
	is_animating = false

#Runs upon exiting state
func _on_exit():
	is_animating = false
	#scythio_animation.stop()
