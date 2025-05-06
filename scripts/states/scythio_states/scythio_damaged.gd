#scythio_damaged
extends ScythioState

#Exports Scythio and her animation node
@export var scythio: PlayerScythio
@export var scythio_animation: AnimatedSprite2D

var is_animating: bool = false

func _ready() -> void:
	#Tracks if animation has finished, and when it has, it runs the "_on_animation_finished()" function
	scythio_animation.animation_finished.connect(_on_animation_finished)

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	#Handles hurt box and Scythio taking damage
	if scythio.damageable == true && scythio.damaged == true:
		lose_health()

func lose_health():
	if !is_animating:
		is_animating = true
		
		scythio.damageable = false
		scythio.health -= scythio.damage_rate
		#print(player.health)
		
		if scythio.health > 0:
			#Plays correct animation based on the direction the player is facing
			if scythio.player_direction == Vector2.LEFT: scythio_animation.play("DMG_L")
			elif scythio.player_direction == Vector2.RIGHT: scythio_animation.play("DMG_R")
			else: scythio_animation.play("DMG_D")
			
			#Triggers i-frames
			i_frames()
		else:
			#print("Scythio has fallen")
			transition.emit("Death")

func i_frames():
	scythio.damageable = false
	#print("I-Frames active")
	await get_tree().create_timer(1.5).timeout
	#print("Scythio is no longer immune")
	scythio.damaged = false
	scythio.damageable = true

#Handles transitioning between states
func _on_next_transitions() -> void:
	if is_animating:
		return
	
	if scythio.health <= 0:
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
	if scythio_animation.animation in ["DMG_R", "DMG_L", "DMG_D"]:
		is_animating = false

#Runs upon entering state
func _on_enter():
	is_animating = false

#Runs upon exiting state
func _on_exit():
	scythio.damaged = false
	is_animating = false
