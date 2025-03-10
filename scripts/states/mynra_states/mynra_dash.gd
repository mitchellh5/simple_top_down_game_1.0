#MynraDash
extends MynraState

#Exports Mynra and her animation node
@export var player: PlayerMynra
@export var player_animation: AnimatedSprite2D

@export var ghost_node: PackedScene				#Exports ghost for ghost frames for after affects of dash animation
@export var dash_cooldown: float = 0.75			#Internal dash cooldown to avoid spamming
@export var ghost_cooldown: float = 0.2			#Internal ghost frame cooldown to avoid smearing

var frame: int									#Used to always display proper frame of ghost animation
var can_dash: bool = true						#Used with cooldown to avoid spamming
var can_ghost: bool = true						#Used with cooldown to avoid smearing
var is_animating: bool = false					#Prevents premature state transitions while mid-animation
var dash_velocity: Vector2 = Vector2.ZERO		#Used to calculate player's dash_velocity
var dash_strength: float = 2.5					#Used to scale player speed while dashing

#Runs every frame
func _on_update(_delta: float) -> void:
	#Tracks if animation has finished, and when it has, it runs the "_on_animation_finished()" function
	player_animation.animation_finished.connect(_on_animation_finished)

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	if player.get_parent().name == "Oblivion":
		can_dash = false
	#Awaits input from player, then, if the cooldown is inactive, runs the "dash()" function
	if Input.is_action_pressed("dash") && can_dash:
		dash()
	
	#While dashing:
	if is_animating:
		#Gets input velocity from the "Game_Input_Events" class,
		#and uses it to calculate the proper direction of the dash
		var input_velocity: Vector2 = Game_Input_Events.velocity_of_movement()
		player.velocity = dash_velocity 
		player.move_and_slide()
		
		#Assuming the ghost cooldown is finished, this adds a ghost at the curent
		#frame to the scene, then increments the frame of the ghost, and triggers
		#the "start_ghost_cooldown()" function. Once the dash is complete, the
		#ghost will have shown three seperate frames, each of a different section of the dash.
		if can_ghost == true:
			can_ghost = false
			var ghost = ghost_node.instantiate()
			ghost.set_property(player.position, $"../../AnimatedSprite2D".scale)
			if ghost is AnimatedSprite2D:
				ghost.animation = player_animation.animation
				ghost.frame = frame
				#ghost.stop()
			get_tree().current_scene.add_child(ghost)
			
			frame = (frame + 1) % player_animation.sprite_frames.get_frame_count(player_animation.animation)
			start_ghost_timer()

#Handles dashing
func dash():
	#As long as there is not a dash animation already in play
	if !is_animating:
		is_animating = true																#Set "is_animating" and  "can_dash" to true to avoid spamming
		can_dash = false
		
		player.damageable = false														#Dashing grants free i-frames
		
		var input_velocity = Game_Input_Events.velocity_of_movement()								#Gets player's current velocity_vector from the "Game_Input_Events" class
		if input_velocity != Vector2.ZERO:															#As long as the velocity vector is not 0, it will set the player to dash
			dash_velocity = input_velocity.normalized() * player.speed * dash_strength				#in the current direction of movement.
		else:																						#Otherwise, it dashes in the direction the player is currently facing
			dash_velocity = player.player_direction.normalized() * player.speed * dash_strength		#(for cases where the player dashes from an idle position)
		
		#Plays correct animation based on the direction the player is facing
		if player.player_direction == Vector2.LEFT: player_animation.play("Dash_L")
		elif player.player_direction == Vector2.RIGHT: player_animation.play("Dash_R")
		elif player.player_direction == Vector2.UP: player_animation.play("Dash_U")
		else: player_animation.play("Dash_D")
		
		#Runs the "start_cooldown()" function to start the "dash_cooldown" timer
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

#Handles transitioning between states
func _on_next_transitions() -> void:
	if is_animating:
		return
	
	if player.damaged:
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

#Tracks when animation is finished
func _on_animation_finished():
	if player_animation.animation in ["Dash_L", "Dash_R", "Dash_D", "Dash_U"]:
		is_animating = false

#Runs upon entering state
func _on_enter():
	frame = 0
	is_animating = false

#Runs upon exiting state
func _on_exit():
	frame = 0
	is_animating = false
	player.damageable = true
	player.damaged = false
