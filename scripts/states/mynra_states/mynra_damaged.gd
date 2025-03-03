#MynraDamaged
extends MynraState

#Exports Mynra and her animation node
@export var player: PlayerMynra
@export var player_animation: AnimatedSprite2D

var is_animating: bool = false

#Runs every frame
func _on_update(_delta: float) -> void:
	player_animation.animation_finished.connect(_on_animation_finished)

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	#Handles hurt box and Mynra taking damage
	if player.damageable == true && player.damaged == true:
		lose_health()

func lose_health():
	if !is_animating:
		is_animating = true
		
		player.damageable = false
		player.health -= player.damage_rate
		#print(player.health)
		
		if player.health > 0:
			#Plays correct animation based on the direction the player is facing
			if player.player_direction == Vector2.LEFT: player_animation.play("DMG_L")
			elif player.player_direction == Vector2.RIGHT: player_animation.play("DMG_R")
			elif player.player_direction == Vector2.UP: player_animation.play("DMG_U")
			else: player_animation.play("DMG_D")
			
			#Triggers i-frames
			i_frames()
		else:
			#print("Mynra has fallen")
			transition.emit("Death")

func i_frames():
	player.damageable = false
	#print("I-Frames active")
	await get_tree().create_timer(1.5).timeout
	#print("Mynra is no longer immune")
	player.damaged = false
	player.damageable = true

#Handles transitioning between states
func _on_next_transitions() -> void:
	if is_animating:
		return
	
	if player.health <= 0:
		transition.emit("Death")
	elif Game_Input_Events.is_movement_input():
		transition.emit("Movement")
	elif Game_Input_Events.is_dashing():
		transition.emit("Dashing")
	elif Game_Input_Events.is_prim_attacking():
		transition.emit("Primary_Attack")
	elif Game_Input_Events.is_sec_attacking():
		transition.emit("Secondary_Attack")
	elif !Game_Input_Events.is_movement_input():
		transition.emit("Idle")

#Checks if animation is still playing
func _on_animation_finished():
	if player_animation.animation in ["DMG_R", "DMG_L", "DMG_D", "DMG_U"]:
		is_animating = false

#Runs upon entering state
func _on_enter():
	is_animating = false

#Runs upon exiting state
func _on_exit():
	player.damaged = false
	is_animating = false
