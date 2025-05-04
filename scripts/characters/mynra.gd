#PlayerMynra
class_name PlayerMynra
extends CharacterBody2D

#Connects to the "State_Machine" script (the main one) and the "State_Machine" node (used specifically for this scene)
@export var State_Machine : NodePath
#@onready var state_machine_instance = get_node("StateMachine") #don't think this is important, commented out, but just incase not deleted (my confidence in my code is unfounded)

#Tracks current state of player
var current_state

#Connects to the player's sprite for animation purposes
@onready var sprite = $AnimatedSprite2D

#Sets up the "Prim_Attack_HB" Area2D for use in states and here
@onready var atk_area = get_node("%Hitbox")
#@onready var hitbox = get_node("$HurtBox/CollisionShape2D")

#Variabls used for Famine (secondary attack)
var target_pos: Vector2												#Tracks the target position so that Famine always spawns from Mynra's current position
var throw_dir: Vector2												#Tracks the direction we want to throw Famine in
const FAMINE_PATH = preload("res://scenes/weapons/famine.tscn")		#Preloads Famine as a scene so that it can be thrown and caught by Mynra

#Tracks if Mynra is the current player character or a companion (set to true by default since she is the main character)
var player = true

#Basic variables for player
var speed = 200					#Sets speed of player movement
var angle: float				#Tracks the direction Mynra is facing
var player_direction: Vector2	#Used to track the direction the player was last facing for idling
var health = 10					#Sets health value for Mynra
var ammo = 1					#Sets ammo for Famine (1, because there is only one)
var collectable: bool			#Sets variable to determine if Famine is currently collectable
var damaged = false				#Used for state transitions
var damageable = true			#Used for i-frames
var damage_rate: int			#Used for determining how much damage the player takes from an attack

#Runs on startup
func _ready():
	#Sets up "atk_area" to monitor the "Prim_Attack_HB" mask, which is
	#used for "get_overlapping_bodies()" script in "Primary_Attack" state
	atk_area.monitoring = true

#This script updates every frame
func _physics_process(delta: float) -> void:	
	#Used to track direction Mynra is facing (based on player input method)
	var dir
	
	if Input.is_action_just_pressed("Switch_Characters") && !GlobalState.in_combat && GlobalState.scene != "Oblivion":
		if player:
			player = false
		else:
			player = true
		_character_swap()
	
	if player:
		#print("Player")
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
		pass
		#print("NPC")
	
	#Is the angle at which the player is facing
	if player:
		angle = rad_to_deg(dir.angle())

func _character_swap() -> void:
	if player:
		set_collision_layer_value(1, true)
		set_collision_mask_value(6, false)
		motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
		add_to_group("Player")
		remove_from_group("Companion")
	else:
		set_collision_layer_value(1, false)
		set_collision_mask_value(6, true)
		motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
		wall_min_slide_angle = 0
		add_to_group("Companion")
		remove_from_group("Player")

#Used for transitioning to the "Damaged" state when Mynra takes damage
func lose_health(dmg):
	damage_rate = dmg
	if damageable:
		damaged = true

#Allows the player to retrieve Famine when the "collectable" bool is set to true, setting the "ammo" value to 1 so that Famine can be thrown again,
#and sets "collectable" back to false to avoid problems with Famine being collected multiple times or immediately after it was thrown
func collect_famine():
	if collectable == true:
		ammo = 1

#Handles i-frames for Mynra (0.67s)
func i_frames():
	damageable = false
	await get_tree().create_timer(0.67).timeout
	damageable = true
