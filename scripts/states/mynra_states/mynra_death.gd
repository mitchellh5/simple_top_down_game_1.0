#MynraDeath
extends MynraState

#Exports Mynra and her animation node
@export var mynra: PlayerMynra
@export var mynra_animation: AnimatedSprite2D

var is_animating: bool = false
var has_died: bool = false

func _ready() -> void:
	#Tracks if animation has finished, and when it has, it runs the "_on_animation_finished()" function
	mynra_animation.animation_finished.connect(_on_animation_finished)

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	#Death animation
	if mynra.health <= 0 && !has_died:
		fatality()

func fatality():
	if !is_animating:
		is_animating = true
		
		mynra.damageable = false
		if mynra.player_direction == Vector2.LEFT: mynra_animation.play("Death_L")
		else: mynra_animation.play("Death_R")
		
		has_died = true

#Handles transitioning between states
func _on_next_transitions() -> void:
	pass

func _on_animation_finished():
	if mynra_animation.animation in ["Death_R", "Death_L"]:
		is_animating = false

#Runs upon entering state
func _on_enter():
	is_animating = false

#Runs upon exiting state
func _on_exit():
	pass
