#Arlithon_Follow_Player
extends Arlithon_State

@export var arlithon: Arlithon
@export var arlithon_animation: AnimatedSprite2D

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	if arlithon.player_in_range:
		arlithon_animation.play("Run")
		var direction = arlithon.player_body.global_position - arlithon.global_position
	
		arlithon.velocity = direction.normalized() * arlithon.speed
	else:
		transition.emit("Idle")

#Handles transitioning between states
func _on_next_transitions() -> void:
	
	if arlithon.player_in_atk_range:
		transition.emit("Attack")
	elif arlithon.companion_in_range && !arlithon.player_in_range:
		transition.emit("Follow_Companion")
	elif !arlithon.player_in_range:
		transition.emit("Idle")

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	pass
