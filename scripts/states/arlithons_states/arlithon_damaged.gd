#Arlithon_Damaged
extends Arlithon_State

@export var arlithon: Arlithon
@export var arlithon_animation: AnimatedSprite2D

var is_animating: bool = false

#Runs every frame
func _on_update(_delta: float) -> void:
	arlithon_animation.animation_finished.connect(_on_animation_finished)

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	if arlithon.damaged:
		damage()

func damage():
	if !is_animating:
		is_animating = true
		
		if arlithon.character.global_position.x - arlithon.global_position.x > 0:
			arlithon_animation.flip_h = true
		else:
			arlithon_animation.flip_h = false
			
		arlithon_animation.play("DMG")
		arlithon.damaged = false

func _on_animation_finished():
	if arlithon_animation.animation == "DMG":
		is_animating = false

#Handles transitioning between states
func _on_next_transitions() -> void:
	if is_animating:
		return
	
	if arlithon.player_in_atk_range:
		transition.emit("Attack")
	elif arlithon.player_in_range:
		transition.emit("Follow_Player")
	else:
		transition.emit("Idle")

#Runs upon entering state
func _on_enter():
	is_animating = false

#Runs upon exiting state
func _on_exit():
	is_animating = false
	arlithon._stunlocked()
