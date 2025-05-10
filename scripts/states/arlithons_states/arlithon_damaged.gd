#Arlithon_Damaged
extends Arlithon_State

@export var arlithon: Arlithon
@export var arlithon_animation: AnimatedSprite2D

var is_animating: bool = false

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	if arlithon.damaged:
		damage()

func damage():
	if !is_animating:
		#print("Ouchie!")
		is_animating = true
		
		if arlithon.character.global_position.x - arlithon.global_position.x > 0:
			#arlithon_animation.flip_h = true
			arlithon.set_facing_left(true)
		else:
			#arlithon_animation.flip_h = false
			arlithon.set_facing_left(false)
			
		arlithon.set_modulation(true)
		await get_tree().create_timer(0.25).timeout  # Wait for 0.25 seconds
		arlithon.set_modulation(false)
		arlithon.damaged = false

#Handles transitioning between states
func _on_next_transitions() -> void:
	
	if arlithon.health <= 0:
		arlithon.is_alive = false
		arlithon.remove_from_group("Arlithons")
		transition.emit("Death")
	elif arlithon.body_in_atk_range:
		transition.emit("Attack")
	elif arlithon.player_in_range || arlithon.companion_in_range:
		transition.emit("Hunt")
	else:
		transition.emit("Idle")

#Runs upon entering state
func _on_enter():
	is_animating = false

#Runs upon exiting state
func _on_exit():
	is_animating = false
	arlithon._stunlocked()
