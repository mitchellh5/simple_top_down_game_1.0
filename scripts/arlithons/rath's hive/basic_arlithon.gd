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

func _check_mutations() -> bool:
	if has_node("Tail_Mutation"):
		damage_dealt = 2
		return true
	else:
		damage_dealt = 1
		return false


#Handles dealing damage to characters
func deal_damage():
	pass
