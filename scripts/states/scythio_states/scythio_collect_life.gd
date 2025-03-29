#FollowPlayerState
extends ScythioState

@export var scythio : PlayerScythio
@export var scythio_animation : AnimatedSprite2D

#tracks current player character for following between levels
var player_character : CharacterBody2D 

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	
	#Checks if Scythio is missing Life (ammo <= 0), and if so, checks if it is closer to him than his current target arlithon
	#and if so, goes and collects Life before attacking his next target
	if scythio.ammo <= 0 && scythio.collecting_life:
		_collect_life()
	else:
		transition.emit("HuntArlithons")

func _collect_life():
	var direction: Vector2 = get_tree().root.find_child("Life", true, false).global_position - scythio.global_position
	var normalized_direction = direction.normalized()
	
	scythio.velocity = direction.normalized() * scythio.speed
	
	#Used for playing the proper animation depending on what direction Scythio is moving (Right, Left, Down, or Up)
	if abs(normalized_direction.x) > abs(normalized_direction.y):
		if normalized_direction.x > 0:
			scythio_animation.play("Run_R")
		else:
			scythio_animation.play("Run_L")
	else:
		if normalized_direction.y > 0:
			scythio_animation.play("Run_D")
		else:
			scythio_animation.play("Run_U")

#Handles transitioning between states
func _on_next_transitions() -> void:
	if scythio.ammo >= 1:
		transition.emit("HuntArlithons")

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	pass
