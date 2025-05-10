#Arlithon_Idle
extends Arlithon_State

@export var arlithon: Arlithon
@export var arlithon_animation: AnimatedSprite2D

var move_dir: Vector2
var wander_time: float

#Randomizes wander time
func randomize_wander():
	move_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(120, 240)

#Runs every frame
func _on_update(_delta: float) -> void:
	if wander_time > 0:
		wander_time -= 1
	else:
		randomize_wander()

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	if !arlithon.player_in_range:
		wander()

#Handles idling
func wander():
	arlithon_animation.play("Fly")
	arlithon.velocity = move_dir * arlithon.speed

#Handles transitioning between states
func _on_next_transitions() -> void:
	
	if arlithon.damaged:
		transition.emit("Damaged")
	else:
		if arlithon.body_in_atk_range:
			transition.emit("Attack")
		else:
			transition.emit("Hunt")
	

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	pass
