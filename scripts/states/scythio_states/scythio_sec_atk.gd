#SecondaryAttack
extends ScythioState

@export var scythio: PlayerScythio
@export var scythio_animation: AnimatedSprite2D

var arlithons

var is_animating: bool = false
var atk_on_cooldown: bool = false

func _ready() -> void:
	#Tracks if animation has finished, and when it has, it runs the "_on_animation_finished()" function
	scythio_animation.animation_finished.connect(_on_animation_finished)

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	arlithons = get_tree().get_nodes_in_group("Arlithons")
	
	if scythio.player:
		if Input.is_action_pressed("secondary_attack"):
			secondary_attack_player()
	elif !scythio.player && scythio.arlithon_in_sec_atk_range:
		secondary_attack_companion()

#Handles throwing Life
func secondary_attack_player():
	# Check if player is animating and has ammo
	if !is_animating and scythio.ammo > 0:
		is_animating = true

		# Detect direction for animation and aiming
		var throw_direction: Vector2
		if Input.get_connected_joypads().size() > 0:
			# Get left stick input direction
			var x_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			var y_dir = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			throw_direction = Vector2(x_dir, y_dir).normalized()
		else:
			# Use mouse position if no controller input
			var mouse_pos = scythio.get_global_mouse_position()
			throw_direction = (mouse_pos - scythio.global_position).normalized()

		# Ensure a valid throw direction
		if throw_direction.length() > 0:
			# Determine the angle for animation
			var throw_angle = rad_to_deg(throw_direction.angle())
			if throw_angle >= -45 and throw_angle < 45:
				scythio_animation.play("Sec_Atk_R")
			elif throw_angle >= 45 and throw_angle < 135:
				scythio_animation.play("Sec_Atk_D")
			elif throw_angle >= -135 and throw_angle < -45:
				scythio_animation.play("Sec_Atk_U")
			else:
				scythio_animation.play("Sec_Atk_L")

			# Instantiate and throw Life
			var life = scythio.LIFE_PATH.instantiate()
			life.aim_life(scythio.global_position, scythio.global_position + throw_direction * 100)  # Apply direction
			get_parent().add_child(life)

			# Update ammo and manage collectability
			scythio.ammo = 0
			scythio.collectable = false
			await get_tree().create_timer(0.05).timeout
			scythio.collectable = true
			
		else:
			if scythio_animation.animation == "Idle_R":
				throw_direction = Vector2(1, 0)
				scythio_animation.play("Sec_Atk_R")
			elif scythio_animation.animation in ["Idle1_D", "Idle2_D", "Idle3_D"]:
				throw_direction = Vector2(0, 1)
				scythio_animation.play("Sec_Atk_D")
			else:
				throw_direction = Vector2(-1, 0)
				scythio_animation.play("Sec_Atk_L")
			
			# Instantiate and throw Life
			var life = scythio.LIFE_PATH.instantiate()
			life.aim_life(scythio.global_position, scythio.global_position + throw_direction * 100)  # Apply direction
			get_parent().add_child(life)

			# Update ammo and manage collectability
			scythio.ammo = 0
			scythio.collectable = false
			await get_tree().create_timer(0.05).timeout
			scythio.collectable = true

func secondary_attack_companion():
	#print("Scythio prepares an attack")
	var distance = scythio.target_arlithon.global_position.distance_to(scythio.global_position)
	if !is_animating && scythio.target_arlithon.is_alive && !atk_on_cooldown && scythio.arlithon_in_sec_atk_range && scythio.ammo > 0 && distance >= 100:
		#print("Scythio has an attack locked on")
		is_animating = true
		atk_on_cooldown = true
		scythio.atk_cooldown_timer.start()
		
		# Detect direction for animation and aiming
		var throw_direction: Vector2
		
		throw_direction = scythio.target_arlithon.global_position - scythio.global_position
		
		
		# Ensure a valid throw direction
		#print(throw_direction)
		if throw_direction.length():
			# Determine the angle for animation
			var throw_angle = rad_to_deg(throw_direction.angle())
			if throw_angle >= -45 and throw_angle < 45:
				scythio_animation.play("Sec_Atk_R")
			elif throw_angle >= 45 and throw_angle < 135:
				scythio_animation.play("Sec_Atk_D")
			elif throw_angle >= -135 and throw_angle < -45:
				scythio_animation.play("Sec_Atk_U")
			else:
				scythio_animation.play("Sec_Atk_L")

			# Instantiate and throw Life
			var life = scythio.LIFE_PATH.instantiate()
			life.aim_life(scythio.global_position, scythio.global_position + throw_direction * 100)  # Apply direction
			get_parent().add_child(life)

			# Update ammo and manage collectability
			scythio.ammo = 0
			scythio.collectable = false
			await get_tree().create_timer(0.5).timeout
			scythio.collectable = true
			
		else:
			if scythio_animation.animation == "Idle_R":
				throw_direction = Vector2(1, 0)
				scythio_animation.play("Sec_Atk_R")
			elif scythio_animation.animation in ["Idle1_D", "Idle2_D", "Idle3_D"]:
				throw_direction = Vector2(0, 1)
				scythio_animation.play("Sec_Atk_D")
			else:
				throw_direction = Vector2(-1, 0)
				scythio_animation.play("Sec_Atk_L")
			
			# Instantiate and throw Life
			var life = scythio.LIFE_PATH.instantiate()
			life.aim_life(scythio.global_position, scythio.global_position + throw_direction * 100)  # Apply direction
			get_parent().add_child(life)

			# Update ammo and manage collectability
			scythio.ammo = 0
			scythio.collectable = false
			await get_tree().create_timer(0.05).timeout
			scythio.collectable = true

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
		elif Game_Input_Events.is_prim_attacking():
			transition.emit("Primary_Attack")
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

#Ensures the animation has finished to avoid overlapping animations
func _on_animation_finished():
	if scythio_animation.animation in ["Sec_Atk_R", "Sec_Atk_L", "Sec_Atk_U", "Sec_Atk_D"]:
		is_animating = false

#Runs when the state is entered
func _on_enter():
	is_animating = false

#Runs when the state is exited
func _on_exit():
	is_animating = false
