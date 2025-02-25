#Arlithon_Attack
extends Arlithon_State

@export var arlithon: Arlithon
@export var arlithon_animation: AnimatedSprite2D

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	if arlithon.player_in_atk_range && !arlithon.stunlocked:
		
		if arlithon.player_body.global_position.x - arlithon.global_position.x > 0:
			arlithon_animation.flip_h = true
		else:
			arlithon_animation.flip_h = false
		
		arlithon.velocity = Vector2.ZERO
		
		if arlithon_animation.animation != "Atk":
			arlithon_animation.play("Atk")
		arlithon_animation.play("Atk")
		arlithon.player_body.lose_health(arlithon.damage_dealt)

#Handles transitioning between states
func _on_next_transitions() -> void:
	
	if arlithon.player_in_atk_range:
		return
	elif arlithon.player_in_range:
		transition.emit("Follow_Player")
	else:
		transition.emit("Idle")

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	pass
