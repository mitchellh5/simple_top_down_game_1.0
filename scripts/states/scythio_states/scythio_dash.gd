#DashState
extends ScythioState

@export var scythio : PlayerScythio
@export var scythio_animation : AnimatedSprite2D

@export var ghost_node: PackedScene				#Exports ghost for ghost frames for after affects of dash animation
@export var dash_cooldown: float = 0.75
@export var ghost_cooldown: float = 0.1

#Dash parameters
@export var dash_speed: float = 500.0				#Speed at which the character will dash
@export var dash_distance: float = 150.0			#Distance traveled by the dash

var dash_duration: float							#Duration of the dash
var frame: int										#Used to track the current frame of animation for ghosting
var can_dash: bool = true							#Used to track when the dash is on "cool down"
var can_ghost: bool = true							#Used to avoid smearing from the ghosting effect
var is_animating: bool = false						#Ensures the dash does not end prematurely due to an unplanned state change
var dash_velocity: Vector2 = Vector2.ZERO			#Velocity of the dash
var distance_covered: float = 0.0					#Tracks how far the character has dashed so that they don't exceed the limit
var start_position: Vector2 = Vector2.ZERO			#Tracks starting position before the dash, used for tracking "distanced traveled"

func _ready() -> void:
	#Tracks if animation has finished, and when it has, it runs the "_on_animation_finished()" function
	scythio_animation.animation_finished.connect(_on_animation_finished)

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	if scythio.get_parent().name == "Oblivion":
		can_dash = false
	
	if scythio.player:
		#Awaits input from player, then, if the cooldown is inactive, runs the "dash()" function
		if Input.is_action_pressed("dash") && can_dash:
			_dash_as_player()
	elif !scythio.player && can_dash:
		_dash_as_companion()
	
	#While dashing:
	if is_animating && scythio.player:
		#Applies dash velocity
		scythio.velocity = dash_velocity
		var prev_position = scythio.position
		scythio.move_and_slide()
		
		#Accumulated distance traveled
		distance_covered += scythio.position.distance_to(prev_position)
		
		#Handles Ghosting effect
		if can_ghost:
			can_ghost = false
			var ghost = ghost_node.instantiate()
			ghost.set_property(scythio.position, $"../../AnimatedSprite2D".scale)
			if ghost is AnimatedSprite2D:
				ghost.animation = scythio_animation.animation
				ghost.frame = frame
			get_tree().current_scene.add_child(ghost)
			
			frame = (frame + 1) % scythio_animation.sprite_frames.get_frame_count(scythio_animation.animation)
			start_ghost_timer()
		
		#Stops dash when target distance is reached
		if distance_covered >= dash_distance:
			_end_dash()
	
	#While dashing:
	elif is_animating && !scythio.player:
		#Gets input velocity from the "Game_Input_Events" class,
		#and uses it to calculate the proper direction of the dash
		
		#Applies dash velocity
		scythio.velocity = dash_velocity
		var prev_position = scythio.position
		scythio.move_and_slide()
		
		#Accumulated distance traveled
		distance_covered += scythio.position.distance_to(prev_position)
		
		#Handles Ghosting effect
		if can_ghost:
			can_ghost = false
			var ghost = ghost_node.instantiate()
			ghost.set_property(scythio.position, $"../../AnimatedSprite2D".scale)
			if ghost is AnimatedSprite2D:
				ghost.animation = scythio_animation.animation
				ghost.frame = frame
			get_tree().current_scene.add_child(ghost)
			
			frame = (frame + 1) % scythio_animation.sprite_frames.get_frame_count(scythio_animation.animation)
			start_ghost_timer()
		
		#Stops dash when target distance is reached
		if distance_covered >= dash_distance:
			_end_dash()

#Handles dashing for player
func _dash_as_player():
	#As long as there is not a dash animation already in play
	if !is_animating:
		is_animating = true
		can_dash = false
		scythio.damageable = false
		
		start_position = scythio.position
		distance_covered = 0.0
		
		var input_velocity = Game_Input_Events.velocity_of_movement()
		var dash_direction: Vector2
		if input_velocity != Vector2.ZERO:
			dash_direction = input_velocity.normalized()
		else:
			dash_direction = scythio.player_direction.normalized()
			
		#Uses the separate dash_speed value in place of the typical player speed from the main script
		dash_velocity = dash_direction * dash_speed
		
		#Plays the proper dash animation dependant on the direction the player is moving
		match scythio.player_direction:
			Vector2.LEFT:
				scythio_animation.play("Dash_L")
			Vector2.RIGHT:
				scythio_animation.play("Dash_R")
			Vector2.UP:
				scythio_animation.play("Dash_U")
			_:
				scythio_animation.play("Dash_D")
		
		#Puts the dash on cooldown
		start_cooldown()

#Handles dashing for companion
func _dash_as_companion():
	if !is_animating:
		is_animating = true																#Set "is_animating" and  "can_dash" to true to avoid spamming
		can_dash = false
		
		scythio.damageable = false														#Dashing grants free i-frames
		
		var input_velocity																			#Gets player's current velocity_vector from the "Game_Input_Events" class
		if scythio.target_arlithon && !scythio.collecting_life:
			input_velocity = scythio.target_arlithon.global_position - scythio.global_position
		elif scythio.collecting_life:
			input_velocity = scythio.get_tree().root.find_child("Life", true, false).global_position - scythio.global_position
		else:
			input_velocity = scythio.player_body.global_position - scythio.global_position
		
		var dash_direction: Vector2
		if input_velocity != Vector2.ZERO:
			dash_direction = input_velocity.normalized()
		else:
			dash_direction = scythio.player_direction.normalized()
			
		#Uses the separate dash_speed value in place of the typical player speed from the main script
		dash_velocity = dash_direction * dash_speed
		
		#Plays the proper dash animation dependant on the direction the player is moving
		match scythio.player_direction:
			Vector2.LEFT:
				scythio_animation.play("Dash_L")
			Vector2.RIGHT:
				scythio_animation.play("Dash_R")
			Vector2.UP:
				scythio_animation.play("Dash_U")
			_:
				scythio_animation.play("Dash_D")
		
		#Puts the dash on cooldown
		start_cooldown()

#Starts the "dash_cooldown" timer
func start_cooldown():
	var cooldown_timer = get_tree().create_timer(dash_cooldown)
	cooldown_timer.timeout.connect(_on_cooldown_finished)

#Once the "dash_cooldown" timer has finished, it sets "can_dash"
#back to true to allow the player to once again dash
func _on_cooldown_finished():
	can_dash = true

#Starts the "ghost_cooldown" timer
func start_ghost_timer():
	var ghost_timer = get_tree().create_timer(ghost_cooldown)
	ghost_timer.timeout.connect(_on_ghost_cooldown_finished)

#Once the "ghost_cooldown" timer has finished, it sets "can_ghost"
#back to true to allow the ghosting to continue
func _on_ghost_cooldown_finished():
	can_ghost = true

#Ends the dash when the character has met the max travel distance
func _end_dash():
	pass

#Handles transitioning between states
func _on_next_transitions() -> void:
	if is_animating:
		return
	
	if scythio.damaged:
		transition.emit("Damage")
	elif scythio.player:
		if Game_Input_Events.is_movement_input():
			transition.emit("Movement")
		elif Game_Input_Events.is_prim_attacking():
			transition.emit("Primary_Attack")
		elif Game_Input_Events.is_sec_attacking():
			transition.emit("Secondary_Attack")
		elif !Game_Input_Events.is_movement_input():
			transition.emit("Idle")
	else:
		var arlithons = get_tree().get_nodes_in_group("arlithons")
		if scythio.collecting_life:
			transition.emit("CollectLife")
		if !arlithons.is_empty() || scythio.target_arlithon:
			transition.emit("HuntArlithons")
		elif arlithons.is_empty() && !scythio.at_player:
			transition.emit("FollowPlayer")
		elif scythio.at_player && !scythio.target_arlithon:
			transition.emit("Idle")

#Tracks when animation is finished
func _on_animation_finished():
	if scythio_animation.animation in ["Dash_L", "Dash_R", "Dash_D", "Dash_U"]:
		is_animating = false

#Runs upon entering state
func _on_enter():
	frame = 0
	is_animating = false

#Runs upon exiting state
func _on_exit():
	frame = 0
	is_animating = false
	scythio.damageable = true
	scythio.damaged = false
