#MynraDash
extends MynraState

# Exports for player and animations
@export var mynra: PlayerMynra
@export var mynra_animation: AnimatedSprite2D

# Exports for ghost node and dash parameters
@export var ghost_node: PackedScene
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
	mynra_animation.animation_finished.connect(_on_animation_finished)

#Updates ever frame
func _on_physics_update(_delta: float) -> void:
	
	#Prevents player from dashing while in Oblivion
	if mynra.get_parent().name == "Oblivion":
		can_dash = false
	
	#Ensures the player attempted a dash and that they can currently dash
	if mynra.player && Input.is_action_pressed("dash") && can_dash:
		dash()
	else:
		transition.emit("Idle")
	
	#Makes sure that a dash is currently in progress
	if is_animating:
		
		#Applies dash velocity
		mynra.velocity = dash_velocity
		var prev_position = mynra.position
		mynra.move_and_slide()
		
		#Accumulated distance traveled
		distance_covered += mynra.position.distance_to(prev_position)
		
		#Handles Ghosting effect
		if can_ghost:
			can_ghost = false
			var ghost = ghost_node.instantiate()
			ghost.set_property(mynra.position, $"../../AnimatedSprite2D".scale)
			if ghost is AnimatedSprite2D:
				ghost.animation = mynra_animation.animation
				ghost.frame = frame
			get_tree().current_scene.add_child(ghost)
			
			frame = (frame + 1) % mynra_animation.sprite_frames.get_frame_count(mynra_animation.animation)
			start_ghost_timer()
		
		#Stops dash when target distance is reached
		if distance_covered >= dash_distance:
			_end_dash()

#Handles the actual dashing
func dash():
	if not is_animating:
		is_animating = true
		can_dash = false
		mynra.damageable = false
		
		start_position = mynra.position
		distance_covered = 0.0
		
		var input_velocity = Game_Input_Events.velocity_of_movement()
		var dash_direction: Vector2
		if input_velocity != Vector2.ZERO:
			dash_direction = input_velocity.normalized()
		else:
			dash_direction = mynra.player_direction.normalized()
			
		#Uses the separate dash_speed value in place of the typical player speed from the main script
		dash_velocity = dash_direction * dash_speed
		
		#Plays the proper dash animation dependant on the direction the player is moving
		match mynra.player_direction:
			Vector2.LEFT:
				mynra_animation.play("Dash_L")
			Vector2.RIGHT:
				mynra_animation.play("Dash_R")
			Vector2.UP:
				mynra_animation.play("Dash_U")
			_:
				mynra_animation.play("Dash_D")
		
		#Puts the dash on cooldown
		start_cooldown()

#Handles the cooldown for the dash
func start_cooldown():
	var cooldown_timer = get_tree().create_timer(dash_cooldown)
	cooldown_timer.timeout.connect(_on_cooldown_finished)

#When the timer ends, allows the player to dash again
func _on_cooldown_finished():
	can_dash = true

#Handles timing the ghost effect to avoid smearing
func start_ghost_timer():
	var ghost_timer = get_tree().create_timer(ghost_cooldown)
	ghost_timer.timeout.connect(_on_ghost_cooldown_finished)

func _on_ghost_cooldown_finished():
	can_ghost = true

#Once the player has reached their max distance, the dash ends and their velocity is set to zero
func _end_dash():
	is_animating = false
	# Optionally, reset the player's velocity or snap to a final position
	mynra.velocity = Vector2.ZERO

#Used the avoid issues with the dash ending prematurely due to unexpected state changes
func _on_animation_finished():
	if mynra_animation.animation in ["Dash_L", "Dash_R", "Dash_D", "Dash_U"]:
		is_animating = false

#Runs when the state is entered
func _on_enter():
	frame = 0
	is_animating = false

#Runs when the state is exited
func _on_exit():
	frame = 0
	is_animating = false
	mynra.damageable = true
	mynra.damaged = false

#Handles transitioning between states
func _on_next_transitions() -> void:
	if is_animating:
		return
	
	if mynra.damaged:
		transition.emit("Damage")
	else:
		if Game_Input_Events.is_movement_input():
			transition.emit("Movement")
		elif Game_Input_Events.is_prim_attacking():
			transition.emit("Primary_Attack")
		elif Game_Input_Events.is_sec_attacking():
			transition.emit("Secondary_Attack")
		elif !Game_Input_Events.is_movement_input():
			transition.emit("Idle")
