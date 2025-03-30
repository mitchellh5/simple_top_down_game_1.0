#Arlithon_Death
extends Arlithon_State

@export var arlithon: Arlithon
@export var arlithon_animation: AnimatedSprite2D

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
	if arlithon.health <= 0:
		arlithon.is_alive = false
		
		#Handles Mutation Spreading
		var other_arlithons = get_tree().get_nodes_in_group("Arlithons")			#Creates a variable "other_arlithons" as a list of each
																					#scene in the "arlithons" group currently in the main scene
		var i = 3																	#Number of times the mutation is allowed to spread
		for node in other_arlithons:
			if node != self && !node.has_node("Tail_Mutation") && i>0:				#Goes through the list of arlithons and adds each mutation
				#print("mutation time")												#currently attached this arlithon to the others (assuming it
																					#has a target and has not yet spent all of its mutations)
				if arlithon.has_node("Tail_Mutation"):
					var tail_mutation = arlithon.tail_mutation_scene.instantiate()
					node.add_child(tail_mutation)
				if arlithon.has_node("Wings_Mutation"):
					var wings_mutation = arlithon.wings_mutation_scene.instantiate()
					node.add_child(wings_mutation)
				i-=1
		
		arlithon.velocity = Vector2.ZERO
		arlithon_animation.play("Death")
		#print(arlithon, "is dead")
		await get_tree().create_timer(3).timeout
		arlithon.queue_free()
	else:
		transition.emit("Idle")

#Runs upon exiting state
func _on_exit():
	pass
