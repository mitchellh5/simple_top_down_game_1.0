#MynraSecondaryAttack
extends MynraState

@export var mynra: PlayerMynra
@export var mynra_animation: AnimatedSprite2D

var is_animating: bool = false

func _ready() -> void:
	#Tracks if animation has finished, and when it has, it runs the "_on_animation_finished()" function
	mynra_animation.animation_finished.connect(_on_animation_finished)

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	if mynra.player && Input.is_action_pressed("secondary_attack"):
		throw_famine()
	else:
		transition.emit("Idle")

#Handles throwing Famine
func throw_famine():
	# Check if player is animating and has ammo
	if !is_animating and mynra.ammo > 0:
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
			var mouse_pos = mynra.get_global_mouse_position()
			throw_direction = (mouse_pos - mynra.global_position).normalized()

		# Ensure a valid throw direction
		if throw_direction.length() > 0:
			# Determine the angle for animation
			var throw_angle = rad_to_deg(throw_direction.angle())
			if throw_angle >= -45 and throw_angle < 45:
				mynra_animation.play("Sec_Atk_R")
			elif throw_angle >= 45 and throw_angle < 135:
				mynra_animation.play("Sec_Atk_D")
			elif throw_angle >= -135 and throw_angle < -45:
				mynra_animation.play("Sec_Atk_U")
			else:
				mynra_animation.play("Sec_Atk_L")

			# Instantiate and throw Famine
			var famine = mynra.FAMINE_PATH.instantiate()
			famine.aim_famine(mynra.global_position, mynra.global_position + throw_direction * 100)  # Apply direction
			get_parent().add_child(famine)

			# Update ammo and manage collectability
			mynra.ammo = 0
			mynra.collectable = false
			await get_tree().create_timer(0.05).timeout
			mynra.collectable = true
			
		else:
			if mynra_animation.animation == "Idle_R":
				throw_direction = Vector2(1, 0)
				mynra_animation.play("Sec_Atk_R")
			elif mynra_animation.animation in ["Idle1_D", "Idle2_D", "Idle3_D"]:
				throw_direction = Vector2(0, 1)
				mynra_animation.play("Sec_Atk_D")
			else:
				throw_direction = Vector2(-1, 0)
				mynra_animation.play("Sec_Atk_L")
			
			# Instantiate and throw Famine
			var famine = mynra.FAMINE_PATH.instantiate()
			famine.aim_famine(mynra.global_position, mynra.global_position + throw_direction * 100)  # Apply direction
			get_parent().add_child(famine)

			# Update ammo and manage collectability
			mynra.ammo = 0
			mynra.collectable = false
			await get_tree().create_timer(0.05).timeout
			mynra.collectable = true
			
	

#Handles transitioning between states
func _on_next_transitions() -> void:
	if is_animating:
		return
	
	if mynra.damaged:
		transition.emit("Damaged")
	else:
		if Game_Input_Events.is_movement_input():
			transition.emit("Movement")
		elif Game_Input_Events.is_prim_attacking():
			transition.emit("Primary_Attack")
		elif Game_Input_Events.is_dashing():
			transition.emit("Dash")
		elif !Game_Input_Events.is_movement_input():
			transition.emit("Idle")

#Ensures the animation has finished to avoid overlapping animations
func _on_animation_finished():
	if mynra_animation.animation in ["Sec_Atk_R", "Sec_Atk_L", "Sec_Atk_U", "Sec_Atk_D"]:
		is_animating = false

#Runs when the state is entered
func _on_enter():
	is_animating = false

#Runs when the state is exited
func _on_exit():
	is_animating = false
