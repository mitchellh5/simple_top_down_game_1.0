#CollectFamineState
extends MynraState

@export var mynra: PlayerMynra
@export var mynra_animation : AnimatedSprite2D

#tracks current player character for following between levels
var player_character : CharacterBody2D 

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	
	#Checks if Mynra is missing Famine (ammo <= 0), and if so, checks if it is closer to him than his current target arlithon
	#and if so, goes and collects Famine before attacking his next target
	if mynra.ammo <= 0 && mynra.collecting_famine && mynra.collectable:
		_collect_famine()
	else:
		transition.emit("HuntArlithons")

func _collect_famine():
	var direction = mynra.to_local(mynra.nav.get_next_path_position()).normalized()
	
	mynra.velocity = direction * mynra.speed
	
	#Used for playing the proper animation depending on what direction Mynra is moving (Right, Left, Down, or Up)
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			mynra_animation.play("Run_R")
		else:
			mynra_animation.play("Run_L")
	else:
		if direction.y > 0:
			mynra_animation.play("Run_D")
		else:
			mynra_animation.play("Run_U")

func _make_path():
	mynra.nav.target_position = mynra.get_tree().root.find_child("Famine", true, false).global_position

func _on_nav_timeout() -> void:
	pass # Replace with function body.

#Handles transitioning between states
func _on_next_transitions() -> void:
	if !mynra.player:
		if mynra.ammo >= 1:
			transition.emit("HuntArlithons")
	else:
		transition.emit("Idle")

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	pass
