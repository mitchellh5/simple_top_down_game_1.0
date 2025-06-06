# Arlthon_Staggered_Stage
extends Arlithon_State

@export var arlithon: Arlithon
@export var arlithon_animation: AnimatedSprite2D

@export var stagger_timer: Timer

# Runs every frame
func _on_update(_delta: float) -> void:
	pass

# Runs every frame
func _on_physics_update(_delta: float) -> void:
	if arlithon.staggered:
		stagger_timer.start()
	
	if arlithon.staggered && arlithon.damaged:
		smiting_blow()

func smiting_blow():
	print("Current arlithon health: ", arlithon.health)
	print("That hit like a truck!")
	arlithon.health -= 5
	print("Current arlithon health: ", arlithon.health)

func _on_stagger_timer_timeout() -> void:
	print("No longer staggered")
	arlithon.staggered = false

# Handles transitioning between states
func _on_next_transitions() -> void:
	if arlithon.staggered:
		return
	
	if !arlithon.staggered:
		transition.emit("Idle")

# Runs upon entering state
func _on_enter():
	print("I'm staggered.")
	arlithon.staggered = true
	arlithon.damageable = true
	arlithon.velocity = Vector2.ZERO

# Runs upon exiting state
func _on_exit():
	arlithon.stagger_bar = 5
	print("I didn't hear no bell.")
