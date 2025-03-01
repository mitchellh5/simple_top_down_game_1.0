#Basic_Arlithon
extends CharacterBody2D
class_name Arlithon

#Exports the arlithon's AnimatedSprite2D node to be called for animations
@export var sprite: AnimatedSprite2D

#Connects the arlithon to the state machine on run time
@export var State_Machine : NodePath
@onready var state_machine_instance = get_node("State_Machine")

#preloads all possible mutations on run time
@onready var tail_mutation_scene: PackedScene = preload("res://scenes/arlithon_mutations/tail_mutation.tscn")
@onready var wings_mutation_scene: PackedScene = preload("res://scenes/arlithon_mutations/wings_mutation.tscn")

#Determines movement speed of the basic arlithon
var speed = 50

#Paths to character Mynra on start up so that it can track the player's location
#NOTE: will need to update this later to be able to track whichever character
#is currently the player character
@onready var character = get_node("/root/Oblivion/PlayerMynra")

var health: int = 3							#Used for tracking health of arlithon
var player_in_range: bool = false			#Used for tracking if player is within range of detection
var player_in_atk_range: bool = false		#Used for tracking if player is in attack range
var player_body: CharacterBody2D			#Represents the player body

var damageable: bool = true					#Used for tracking i-frames
var damaged: bool = false					#Detects when arlithon receives damage
var smote: bool = false						#Determines how arlithon was slain
var stunlocked: bool = false				#Used for determining if the player is currently stun locking the arlithon
var damage_dealt = 1						#How much damage it deals to the player

var is_targeted_by_player : bool			#Used to track if this is being targeted by the player so that the companion can assist even if it is mutated
var is_mutated : bool						#Used to track if the arlithon is currently mutated so that the companion knows not to target it unless the player does or it is the last remaining arlithon
var target_locked : bool = false			#Used to track to make sure the arlithon has been damaged in the last 7 seconds

func _ready():
	_check_mutations()

#Runs each frame
func _physics_process(delta: float) -> void:
	move_and_slide()
	if velocity.x > 0:
		$Test_Arlithon.flip_h = true
	else:
		$Test_Arlithon.flip_h = false
	
	for body in $Character_Detection.get_overlapping_bodies():
		if body.is_in_group("player"):
			player_body = body
			player_in_range = true
	
	for body in $Attack.get_overlapping_bodies():
		if body.has_method("lose_health"):
			player_body = body
			player_in_atk_range = true
	
	_check_mutations()
	_is_being_targeted()
	print(is_targeted_by_player)

func _on_attack_body_exited(body: Node2D) -> void:
	if body.has_method("lose_health"):
		player_in_atk_range = false

func _on_character_detection_body_exited(body: Node2D) -> void:
	if body == player_body:
		player_in_range = false
		#print("Player not detected in detection area")

#Handles taking damage
func take_damage():
	if damageable:
		health -= 1
		if health > 0:
			damaged = true
			stunlocked = true
			state_machine_instance.transition_to("Damaged")
			#print(health)
		else:
			state_machine_instance.transition_to("Death")

func _stunlocked():
	await get_tree().create_timer(5).timeout
	stunlocked = false
	#print("Can now attack")

#Checks this arlithons current mutations each frame to see if it is
#mutated (used for targeting purposes for the companion), and if so,
#which mutations it has (to alter the arlithon's stats accordingly)
func _check_mutations():
	if has_node("Tail_Mutation"):
		damage_dealt = 2
		is_mutated = true
	else:
		damage_dealt = 1
		is_mutated = false

#This is the logic used for tracking when this arlithon is currently
#being targeted by the player character
func _is_being_targeted() -> void:
	var other_arlithons = get_tree().get_nodes_in_group("arlithons")		#Gets list of all arlithons in the current scene
		
	if damaged:												#If this arlithon is damaged
		for node in other_arlithons:						#It parses through all other arlithons
			if node != self && node.is_targeted_by_player:	#And if that arlithon is not itself and is currently being targeted by the PC
				node.is_targeted_by_player = false			#It will set that arlithon to no longer being targeted by the PC
		is_targeted_by_player = true						#Then it will set itself as the current target
		$TargetLocked.start()								#And start the timer (which locks it as the target as long is it is damaged by the player every 7s or less)
	
	elif other_arlithons.size() == 1:						#As long as this is the only arlithon in the current scene
		is_targeted_by_player = true						#It is always considered the targeted arlithon
	
	elif $TargetLocked.is_stopped():						#Once the 7s timer runs out, if this arlithon is not being damaged
		is_targeted_by_player = false						#It is removed as the current target

func _on_target_locked_timeout() -> void:
	if !damaged:
		is_targeted_by_player = false

#Handles dealing damage to characters
func deal_damage():
	pass
