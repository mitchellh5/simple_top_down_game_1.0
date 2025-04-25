#Basic_Arlithon
extends CharacterBody2D
class_name Arlithon

#Exports the arlithon's AnimatedSprite2D node to be called for animations
@export var sprite: AnimatedSprite2D

#Connects the arlithon to the state machine on run time
@export var State_Machine : NodePath
@onready var state_machine_instance = get_node("State_Machine")

#preloads all possible mutations on run time
@onready var armor_mutation_scene: PackedScene = preload("res://scenes/arlithon_mutations/pryd/armor_mutation.tscn")
@onready var barbed_stinger_mutation_scene: PackedScene = preload("res://scenes/arlithon_mutations/pryd/barbed_stinger_mutation.tscn")
@onready var hatchling_mutation_scene: PackedScene = preload("res://scenes/arlithon_mutations/pryd/hatchling_mutation.tscn")
@onready var stinger_mutation_scene: PackedScene = preload("res://scenes/arlithon_mutations/pryd/stinger_mutation.tscn")

#Determines movement speed of the basic arlithon
var speed = 50

#Paths to character Mynra on start up so that it can track the player's location
#NOTE: will need to update this later to be able to track whichever character
#is currently the player character
@onready var character = get_tree().get_first_node_in_group("Player")
@onready var companion = get_tree().get_first_node_in_group("Companion")

@onready var prim_atk_range = get_node("%Attack")

signal direction_changed(flip_h: bool)		#Used to dertmine the arlithon's current facing direction so that any
var facing_left = false						#mutations can animate properly in the same direction


var health: int = 3							#Used for tracking health of arlithon
var player_in_range: bool = false			#Used for tracking if player is within range of detection
var player_in_atk_range: bool = false		#Used for tracking if player is in attack range
var player_body: CharacterBody2D			#Represents the player body

var companion_body: CharacterBody2D			#Represents the companion's body
var companion_in_range: bool = false		#Used for tracking if companion is within range of detection
var companion_in_atk_range: bool = false	#Used for tracking if companion is in attack range

var damageable: bool = true					#Used for tracking i-frames
var damaged: bool = false					#Detects when arlithon receives damage
var smote: bool = false						#Determines how arlithon was slain
var stunlocked: bool = false				#Used for determining if the player is currently stun locking the arlithon
var damage_dealt = 1						#How much damage it deals to the player

var is_targeted_by_player : bool			#Used to track if this is being targeted by the player so that the companion can assist even if it is mutated
var target_locked : bool = false			#Used to track to make sure the arlithon has been damaged in the last 7 seconds
var is_alive : bool = true					#Used to track if this arlithon is currently alive (so that companions won't hunt dead bodies)

#Mutation variables
var is_mutated: bool = false				#Used to track if the arlithon is currently mutated so that the companion knows not to target it unless the player does or it is the last remaining arlithon

#Tracks all mutations the arlithon currently has to ensure appropriate animation
var has_armor: bool = false
var has_barbed_stinger: bool = false
var has_hatchling: bool = false
var has_stinger: bool = false			

signal dead									#Used to signal to companion that the enemy has died

func _ready():
	prim_atk_range.monitoring = true
	_check_mutations()

#Runs each frame
func _physics_process(delta: float) -> void:
	#If the arlithon is dead, it removes itself from the "Arlithons" group
	#This is to help companion AI avoid hunting arlithons that are already dead
	if health <= 0:
		emit_signal("dead")
		remove_from_group("Arlithons")
		is_alive = false
		#print("I'm dead and have removed myself from the group of arlithons")
	
	move_and_slide()
	if velocity.x > 0:
		#$Test_Arlithon.flip_h = true
		set_facing_left(true)
	else:
		#$Test_Arlithon.flip_h = false
		set_facing_left(false)
	
	#for body in $Character_Detection.get_overlapping_bodies():
		#if body.is_in_group("Player"):
			#player_body = body
			#player_in_range = true
	
	player_body = get_tree().get_first_node_in_group("Player")
	companion_body = get_tree().get_first_node_in_group("Companion")
	
	var distance_from_player = player_body.global_position - global_position
	var distance_from_companion
	if companion_body:
		distance_from_companion = companion_body.global_position - global_position
	else:
		distance_from_companion = Vector2(1000000,1000000)
	
	if distance_from_player > distance_from_companion:
		player_in_range = false
		companion_in_range = true
	else:
		player_in_range = true
		companion_in_range = false
	
	for body in $Attack.get_overlapping_bodies():
		if body.has_method("lose_health"):
			player_body = body
			player_in_atk_range = true
	
	_check_mutations()
	_is_being_targeted()
	#print(is_targeted_by_player)

func _on_attack_body_exited(body: Node2D) -> void:
	if body.has_method("lose_health"):
		player_in_atk_range = false
#
#func _on_character_detection_body_exited(body: Node2D) -> void:
	#if body == player_body:
		#player_in_range = false
		##print("Player not detected in detection area")

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
	#Checks and applies modifiers for "stinger" mutation
	if has_node("Stinger_Mutation"):
		#print("I have a stinger! Stabby stabby stabby!")
		damage_dealt = 2
		is_mutated = true
	else:
		damage_dealt = 1
		is_mutated = false
	
	

#This is the logic used for tracking when this arlithon is currently
#being targeted by the player character
func _is_being_targeted() -> void:
	var other_arlithons = get_tree().get_nodes_in_group("Arlithons")		#Gets list of all arlithons in the current scene
		
	if !is_alive:
		is_targeted_by_player = false
	elif damaged:												#If this arlithon is damaged
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

func set_facing_left(value: bool) -> void:
	if facing_left != value:
		facing_left = value
		$Test_Arlithon.flip_h = value
		emit_signal("direction_changed", value)
