#MynraDamaged
extends MynraState

#Exports Mynra and her animation node
@export var mynra: PlayerMynra
@export var mynra_animation: AnimatedSprite2D

var is_animating: bool = false

func _ready() -> void:
	#Tracks if animation has finished, and when it has, it runs the "_on_animation_finished()" function
	mynra_animation.animation_finished.connect(_on_animation_finished)

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	#Handles hurt box and Mynra taking damage
	if mynra.damageable == true && mynra.damaged == true:
		lose_health()

func lose_health():
	if !is_animating:
		is_animating = true
		
		mynra.damageable = false
		mynra.health -= mynra.damage_rate
		print(mynra.health)
		
		if mynra.health > 0:
			#Plays correct animation based on the direction the player is facing
			if mynra.player_direction == Vector2.LEFT: mynra_animation.play("DMG_L")
			elif mynra.player_direction == Vector2.RIGHT: mynra_animation.play("DMG_R")
			elif mynra.player_direction == Vector2.UP: mynra_animation.play("DMG_U")
			else: mynra_animation.play("DMG_D")
			
			#Triggers i-frames
			i_frames()
		else:
			#print("Mynra has fallen")
			transition.emit("Death")

func i_frames():
	mynra.damageable = false
	#print("I-Frames active")
	await get_tree().create_timer(0.5).timeout
	#print("Mynra is no longer immune")
	mynra.damaged = false
	mynra.damageable = true

#Handles transitioning between states
func _on_next_transitions() -> void:
	if is_animating:
		return
	
	if mynra.health <= 0:
		transition.emit("Death")
	elif Game_Input_Events.is_movement_input():
		transition.emit("Movement")
	elif Game_Input_Events.is_dashing():
		transition.emit("Dashing")
	elif Game_Input_Events.is_blocking():
		transition.emit("Block")
	elif Game_Input_Events.is_prim_attacking():
		transition.emit("Primary_Attack")
	elif Game_Input_Events.is_sec_attacking():
		transition.emit("Secondary_Attack")
	elif !Game_Input_Events.is_movement_input():
		transition.emit("Idle")

#Checks if animation is still playing
func _on_animation_finished():
	if mynra_animation.animation in ["DMG_R", "DMG_L", "DMG_D", "DMG_U"]:
		is_animating = false

#Runs upon entering state
func _on_enter():
	is_animating = false

#Runs upon exiting state
func _on_exit():
	mynra.damaged = false
	is_animating = false
