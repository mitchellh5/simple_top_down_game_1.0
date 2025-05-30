#MynraState
extends MynraState

@export var mynra: PlayerMynra
@export var mynra_animation: AnimatedSprite2D

var is_animating: bool = false
var is_blocking: bool = false
var is_parrying: bool = false

func _ready() -> void:
	#Tracks if animation has finished, and when it has, it runs the "_on_animation_finished()" function
	mynra_animation.animation_finished.connect(on_animation_finished)

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	if mynra.player && Input.is_action_pressed("block_parry"):
		mynra.is_blocking = true
		var direction: Vector2 = Game_Input_Events.movement_input()					#Used to determine animation direction (cardinal)
		var input_velocity: Vector2 = Game_Input_Events.velocity_of_movement()		#Used to determine movement velocity (8-directional)
		
		#Tracks current movement direction and stores it so that other
		#states (such as idle) animate properly when they are switched to
		if direction != Vector2.ZERO:
			mynra.player_direction = direction
		
		#Handles actual player movement
		mynra.velocity = input_velocity * mynra.speed
		mynra.move_and_slide()
	else:
		mynra.is_blocking = false
		

func on_animation_finished() -> void:
	if mynra_animation.animation in ["Block_R", "Block_L", "Block_U", "Block_D"]:
		is_animating = false

func _on_parry_timeout() -> void:
	mynra.is_parrying = false
	print("Mynra is no longer parrying and has reverted to blocking")

#Handles transitioning between states
func _on_next_transitions() -> void:
	
	if mynra.is_blocking:
		return
	
	if mynra.health <= 0:
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

#Runs upon entering state
func _on_enter():
	mynra.speed /= 2
	mynra.is_parrying = true
	mynra.parry_window.start()
	print("Parrying")

#Runs upon exiting state
func _on_exit():
	mynra.speed *= 2
