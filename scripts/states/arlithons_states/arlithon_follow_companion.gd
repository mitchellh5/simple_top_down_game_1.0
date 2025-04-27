#Arlithon_Follow_Companion
extends Arlithon_State

@export var arlithon: Arlithon
@export var arlithon_animation: AnimatedSprite2D

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	arlithon_animation.play("Fly")
	var direction = arlithon.to_local(arlithon.nav.get_next_path_position()).normalized()

	arlithon.velocity = direction.normalized() * arlithon.speed

func _make_path():
	if arlithon.companion_body:
		arlithon.nav.target_position = arlithon.companion_body.global_position

func _on_nav_timeout() -> void:
	_make_path()

#Handles transitioning between states
func _on_next_transitions() -> void:
	
	if arlithon.player_in_atk_range:
		transition.emit("Attack")
	elif !arlithon.companion_in_range && arlithon.player_in_range:
		transition.emit("Follow_Player")
	elif !arlithon.companion_in_range:
		transition.emit("Idle")

#Runs upon entering state
func _on_enter():
	_make_path()

#Runs upon exiting state
func _on_exit():
	pass
