#Arlithon_State
extends Node
class_name Arlithon_State

signal transition			#Signal is called by outside function whenever a state change is needed	

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	pass

#Handles transitioning between states
func _on_next_transitions() -> void:
	pass

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	pass
