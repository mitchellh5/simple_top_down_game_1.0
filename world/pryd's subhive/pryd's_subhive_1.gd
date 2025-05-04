#----------------------------------------------------------------
#
#This code's entire purpose is to track if there are any living
#in the current scene. This is meant to prevent the player from
#swapping characters while in the middle of combat. Once all
#of the arlithons have died and/or de-queued, the player will
#be able to swap between the current active characters before
#entering the next room.
#
#----------------------------------------------------------------
extends Node2D

var arlithons							#Used to track the current arlithons in the scene
var one_still_lives: bool = true		#Tracks if there are any living arlithons in the scene

#Runs every frame
func _physics_process(delta: float) -> void:
	arlithons = get_tree().get_nodes_in_group("Arlithons")				#Gets every arlithon in the current scene
	
	#Runs to see if there are any living arlithons that have not yet de-queued
	if _are_they_all_dead():
		one_still_lives = false
	
	#If any arlithons are currently alive, the player is not allowed
	#to swap between characters. If they are all dead or de-queued,
	#the player can swap at will on their way to the next section.
	if one_still_lives || arlithons.size() >= 1:
		GlobalState.in_combat = true
	else:
		GlobalState.in_combat = false

#Used to check if there are any living arlithons in the current
#scene, returning true once it finds any that return "is_alive"
#as true, and returning false if it goes through every node
#with none returning as alive.
func _are_they_all_dead() -> bool:
	for node in arlithons:
		if node.is_alive:
			return false
	return true
