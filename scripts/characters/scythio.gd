#PlayerScythio
extends CharacterBody2D
class_name PlayerScythio

#Connects to state machine
@export var State_Machine : Node

#Links the navigation2d node to the enemy for pathfinding
@onready var nav: NavigationAgent2D = $NavigationAgent2D

#Tracks current state of Scythio
var current_state
 
#Connects to AnimatedSprite2D for handling animations
@onready var spriteScythio = $AnimatedSprite2D
 
@onready var atk_area = get_node("%Hitbox")					#Sets up primary attack hit box
@onready var player_detect = get_node("%PlayerDetection")		#Sets up player detection area
@onready var prim_atk_range = get_node("%PrimAtkRange")			#Sets up primary attack range area to detect when enemy is within primary attack range (companion mode only)
@onready var sec_atk_range = get_node("%SecAtkRange")			#Sets up sec_attack range area for ensuring an enemy is in range
@onready var interact_area = get_node("%InteractionArea")		#Sets up interaction area for player interactions
@onready var los = $LineOfSight									#Sets up line of sight

@onready var atk_cooldown_timer: Timer = $Prim_Atk_Cooldown		#Cooldown timers for when in companion mode to ensure balance (the player should be allowed to do more than
																#just watch the companion tear everything to shreds around them)

#Variabls used for Life (secondary attack)
var target_pos: Vector2												#Tracks the target position so that Life always spawns from Mynra's current position
var throw_dir: Vector2												#Tracks the direction we want to throw Life in
var enemy_spotted: bool = false										#Ensures the enemy is within line of sight
var life_spotted: bool = false										#Ensures life is in los for dashing purposes
const LIFE_PATH = preload("res://scenes/weapons/life.tscn")			#Preloads Life as a scene so that it can be thrown and caught by Mynra

#Tracks if Scythio is the current player character, or a companion (set to false by default)
@onready var player = false

#Used for tracking player in main scene
var arlithon_in_atk_range: bool = false		#Used for tracking if player is in attack range
var player_body : CharacterBody2D			#Represents the player body
var at_player : bool = false				#Tracks when this is close enough to the player to start idling when in follow mode
var player_spotted: bool = false			#Used to make sure the player is in line of sight can be dashed towards (prevents
											#the character from repeatedly dashing into a wall as they attempt to reach the player)

#Basic variables for player
var speed = 200					#Sets speed of player movement
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
var collecting_life : bool = false			#Used to track if Scythio is currently going to collect Life instead of hunt arlithons

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
	
	if Input.is_action_just_pressed("Switch_Characters") && !GlobalState.in_combat && GlobalState.scene != "Oblivion":
		if player:
			player = false
		else:
			player = true
		#print(self, "Has switched to player: ", player)
		_character_swap()
	
	if player:
		#print("I'm a player")
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
		#print("Im an NPC")
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
				los.look_at(target_arlithon.global_position)
				_check_los_enemy()
				if enemy_spotted:
					#print("Enemy spotted!")
					arlithon_in_sec_atk_range = true
			#elif body != target_arlithon && arlithon_in_sec_atk_range:
				#arlithon_in_sec_atk_range = false
		
		player_body = get_tree().get_first_node_in_group("Player")
		
		var distance_from_player
		var distance_from_life
		var distance_from_arlithon
		
		if ammo <= 0:
			distance_from_life = global_position.distance_to(get_tree().root.find_child("Life", true, false).global_position)
		else:
			distance_from_life = 10000000000
		
		if target_arlithon:
			distance_from_arlithon = global_position.distance_to(target_arlithon.global_position)
		else:
			distance_from_arlithon = 10000000000
		
		if distance_from_arlithon < distance_from_life:
			nav.target_position = target_arlithon.global_position
			collecting_life = false
		elif ammo <= 0:
			_check_los_life()
			collecting_life = true
			nav.target_position = get_tree().root.find_child("Life", true, false).global_position
		elif player_body:
			_check_los_player()
			collecting_life = false
			nav.target_position = player_body.global_position
		
	#print(arlithon_in_prim_atk_range)
	#print(target_arlithon)
	#_check_player_range()
 	
	if player:
		angle = rad_to_deg(dir.angle())

func _character_swap() -> void:
	if player:
		set_collision_layer_value(1, true)
		set_collision_layer_value(6, false)
		motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
		add_to_group("Player")
		remove_from_group("Companion")
		#print("I am, Scythio, I am now in group ", self.get_groups(), " and my layer 1 is set to ", get_collision_layer_value(1), " and my layer 6 is ", get_collision_layer_value(6))
	else:
		set_collision_layer_value(1, false)
		set_collision_layer_value(6, true)
		motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
		wall_min_slide_angle = 0
		add_to_group("Companion")
		remove_from_group("Player")
		var nodes_in_group = get_tree().get_nodes_in_group("Player")
		if !nodes_in_group.is_empty():
			player_body = nodes_in_group[0] as CharacterBody2D
		else:
			print("That's weird, I don't see any players here")
		

func _check_los_enemy() -> bool:
	var collider = los.get_collider()
	if collider and collider.is_in_group("Arlithons"):
		enemy_spotted = true
		return true
	else:
		return false

func _check_los_player() -> bool:
	var collider = los.get_collider()
	if collider && collider.is_in_group("Player"):
		player_spotted = true
		return true
	else:
		return false

func _check_los_life() -> bool:
	var collider = los.get_collider()
	if collider && collider.is_in_group("Player"):
		life_spotted = true
		return true
	else:
		return false

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

#Used for transitioning to the "Damaged" state when Mynra takes damage
func lose_health(dmg):
	damage_rate = dmg
	if damageable:
		damaged = true
		print(health)

func collect_life():
	if collectable:
		#print("Life collected")
		ammo = 1
		_secondary_atk_cd()
 
func _secondary_atk_cd():
	sec_atk_cooldown = true
	await get_tree().create_timer(0.5).timeout
	sec_atk_cooldown = false

#Handles dialogue (my heaven above, this is going to look like a freaking nightmare fairly
#soon, and I am horrified at the thought of trying to trouble shoot it when that happens.)
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("interact"):
		#for body in $InteractionArea.get_overlapping_bodies():
			#if body.is_in_group("Player"):
				#if GlobalState.sun == "Prelude" && GlobalState.scythio_dt == 0 && GlobalState.mynra_dt == 0:
					#DialogueManager.start_dialogue(player_body.global_position, DialogueTree.playtest_m_s_0)
					#GlobalState.scythio_dt += 1
					#GlobalState.mynra_dt += 1
				#if GlobalState.sun == "Prelude" && GlobalState.scythio_dt == 1 && GlobalState.mynra_dt == 1:
					#DialogueManager.start_dialogue(player_body.global_position, DialogueTree.mynra_meets_scythio_1)
					#GlobalState.scythio_dt += 1
					#GlobalState.mynra_dt += 1
