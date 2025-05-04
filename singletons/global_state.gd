#-------------------------------------------------------
#This handles all of the global states of the game.
#It will track at what point the player is at, such
#as the current sun, hive, player character, and
#companion to the player character. This can all be
#used to display proper dialogue, play the correct
#cutscene, and everything else depending on how far
#into the game the player currently is.
#-------------------------------------------------------
extends Node

#Tracks how far the player is into the game
var sun: String = "Prelude"					#Tracks the current sun (starting at the prelude)
var hive: String = ""						#Tracks the current hive (blank since we start in Oblivion)
var scene: String = "Oblivion"				#Tracks the current scene (starting in Oblivion)
var has_conquered: Array[String]			#Tracks which hives the player has played through so far
var has_witnessed: Array[String]			#Tracks which suns the player has played through so far

#Tracks how far the player is into the story (dialogue specifically)
var scythio_dt: int = 0						#Tracks Scythio's dialogue tree
var mynra_dt: int = 0						#Tracks Mynra's dialogue tree

#Tracks current player/companion roles
var companion: String = "Scythio"			#Tracks the current companion (starting as Scythio)
var player: String = "Mynra"				#Tracks the current PC (starting as Mynra)

#Tracks current pause and transition state for the game
var input_paused: bool = false				#Handles pausing player input during dialogue and cutscenes
var ready_to_go: bool = true				#Handles waiting for scene transitions
var in_combat: bool = false					#As long as the player is in combat (an arlithon exists within the current main scene)
											#this returns true, and prevents character swapping
