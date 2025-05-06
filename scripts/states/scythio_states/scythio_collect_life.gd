#CollectLifeState
extends ScythioState

@export var scythio: PlayerScythio
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
	if scythio.ammo <= 0 && scythio.collecting_life && scythio.collectable:
		_collect_life()
	else:
		transition.emit("HuntArlithons")

func _collect_life():
	var direction = scythio.to_local(scythio.nav.get_next_path_position()).normalized()
	
	scythio.velocity = direction * scythio.speed
	
	#Used for playing the proper animation depending on what direction Scythio is moving (Right, Left, Down, or Up)
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			scythio_animation.play("Run_R")
		else:
			scythio_animation.play("Run_L")
	else:
		if direction.y > 0:
			scythio_animation.play("Run_D")
		else:
			scythio_animation.play("Run_U")

func _make_path():
	scythio.nav.target_position = scythio.get_tree().root.find_child("Life", true, false).global_position

func _on_nav_timeout() -> void:
	pass # Replace with function body.

#Handles transitioning between states
func _on_next_transitions() -> void:
	if !scythio.player:
		if scythio.ammo >= 1:
			transition.emit("HuntArlithons")
	else:
		transition.emit("Idle")

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	pass
