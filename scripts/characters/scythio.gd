#PlayerScythio
extends CharacterBody2D
class_name PlayerScythio

#Connects to state machine
@export var State_Machine : Node

#Tracks current state of Scythio
var current_state

#Connects to AnimatedSprite2D for handling animations
@onready var spriteScythio = $AnimatedSprite2D

@onready var atk_area = get_node("%PrimAtkHB")					#Sets up primary attack hit box
@onready var player_detect = get_node("%PlayerDetection")		#Sets up player detection area
@onready var prim_atk_range = get_node("%PrimAtkRange")			#Sets up primary attack range area to detect when enemy is within primary attack range (companion mode only)
@onready var sec_atk_range = get_node("%SecAtkRange")
@onready var interact_area = get_node("%InteractionArea")
@onready var atk_cooldown_timer: Timer = $Prim_Atk_Cooldown

#Variabls used for Life (secondary attack)
var target_pos: Vector2												#Tracks the target position so that Life always spawns from Mynra's current position
var throw_dir: Vector2												#Tracks the direction we want to throw Life in
const LIFE_PATH = preload("res://scenes/weapons/life.tscn")			#Preloads Life as a scene so that it can be thrown and caught by Mynra


#Tracks if Scythio is the current player character, or a companion (set to false by default)
@onready var player = false

#Used for tracking player in main scene
var arlithon_in_atk_range: bool = false		#Used for tracking if player is in attack range
var player_body : CharacterBody2D			#Represents the player body
var at_player : bool = false				#Tracks when this is close enough to the player to start idling when in follow mode

#Basic variables for player
var speed : int					#Sets speed of player movement
var angle : float				#Tracks the direction Mynra is facing
var player_direction : Vector2	#Used to track the direction the player was last facing for idling
var health = 10					#Sets health value for Mynra
var ammo = 1					#Sets ammo for Life (1, because there is only one)
var collectable: bool			#Sets variable to determine if Life is currently collectable
var damaged = false				#Used for state transitions
var damageable = true			#Used for i-frames
var damage_rate : int			#Used for determining how much damage the player takes from an attack

#Companion specific variabls
var arlithon_in_prim_atk_range : bool
var arlithon_in_sec_atk_range : bool
var target_arlithon : CharacterBody2D
var sec_atk_cooldown : bool = false

#Runs on startup
func _ready():
	#Sets up "atk_area" to monitor the "Prim_Attack_HB" mask, which is
	#used for "get_overlapping_bodies()" script in "Primary_Attack" state
	atk_area.monitoring = true
	player_detect.monitoring = true
	prim_atk_range.monitoring = true
	sec_atk_range.monitoring = true
	interact_area.monitoring = true
	
	
	
	var nodes_in_group = get_tree().get_nodes_in_group("Player")
	if !nodes_in_group.is_empty():
		player_body = nodes_in_group[0] as CharacterBody2D
	else:
		print("That's weird, I don't see any players here")

#Runs every frame
func _physics_process(delta: float) -> void:
	var dir
	if player:
		speed = 200
		add_to_group("Player")
		remove_from_group("Companion")
		if Input.get_connected_joypads().size() > 0:
			var x_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			var y_dir= Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			dir = Vector2(x_dir, y_dir)
			if dir.length() > 0.1:
				dir = dir.normalized()
		else:
			var cursor_position = get_viewport().get_mouse_position()
			dir = (cursor_position - global_position).normalized()
			if dir.length() > 0:
				dir = dir.normalized()
	elif !player:
		speed = 150
		add_to_group("Companion")
		remove_from_group("Player")
		move_and_slide()
		#print("NPC")
		for body in $PrimAtkRange.get_overlapping_bodies():
			if body == target_arlithon:
				#print(target_arlithon)
				#print("enemy spotted")
				arlithon_in_prim_atk_range = true
			elif body != target_arlithon && arlithon_in_prim_atk_range:
				arlithon_in_prim_atk_range = false
				#print("I'm an idiot swinging in the wind, ungabungabingaboo")
		
		for body in $SecAtkRange.get_overlapping_bodies():
			if body == target_arlithon:
				#print("Enemy spotted!")
				arlithon_in_sec_atk_range = true
			#elif body != target_arlithon && arlithon_in_sec_atk_range:
				#arlithon_in_sec_atk_range = false
	
	#print(arlithon_in_prim_atk_range)
	#print(target_arlithon)
	#_check_player_range()
	
	#angle = rad_to_deg(dir.angle())

func _find_player_node() -> void:
	var nodes_in_group = get_tree().get_nodes_in_group("Player")
	if !nodes_in_group.is_empty():
		player_body = nodes_in_group[0] as CharacterBody2D
	else:
		print("That's weird, I don't see any players here")

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body == player_body:
		at_player = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body == player_body:
		at_player = false

func _on_prim_atk_range_body_exited(body: Node2D) -> void:
	if body == target_arlithon:
		arlithon_in_prim_atk_range = false

func _on_sec_atk_range_body_exited(body: Node2D) -> void:
	if body == target_arlithon:
		#print("Mission failed, we'll get 'em next time.")
		arlithon_in_sec_atk_range = false

#func _on_prim_atk_range_body_entered(body: Node2D) -> void:
	#if body == target_arlithon:
		##print("Enemy spotted!")
		#arlithon_in_prim_atk_range = true

func collect_life():
	print("Life collected")
	ammo = 1
	_secondary_atk_cd()

func _secondary_atk_cd():
	sec_atk_cooldown = true
	await get_tree().create_timer(5).timeout
	sec_atk_cooldown = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		for body in $InteractionArea.get_overlapping_bodies():
			if body.is_in_group("Player"):
				if GlobalState.sun == "Prelude":
					DialogueManager.start_dialogue(player_body.global_position, DialogueTree.mynra_meets_scythio)
