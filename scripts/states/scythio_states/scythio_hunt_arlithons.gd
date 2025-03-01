#HuntArlithons
extends ScythioState

@export var scythio : PlayerScythio
@export var scythio_animation : AnimatedSprite2D

var arlithon : CharacterBody2D		#tracks the current target arlithon
var arlithons						#Scans current scene to check for any arlithons currently in it

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	arlithons = get_tree().get_nodes_in_group("Arlithons")
	
	for node in arlithons:
		if !node.is_mutated:
			print("Following arlithon: ", node)
		elif (node.is_mutated && node.is_targeted_by_player) || node.is_last_arlithon:
			print("Assisting player with arlithon: ", node)

#Handles transitioning between states
func _on_next_transitions() -> void:
	pass

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	pass
