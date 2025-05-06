#Idle
extends MynraState

@export var mynra : PlayerMynra
@export var mynra_animation : AnimatedSprite2D

var waiting: bool = false

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	#Plays the proper animation based on the direction the player was facing
	#when they entered the state (NOTE: there are no "Idle_U" animations)
	var anim_name : String
	
	if mynra.player:
		if mynra.player_direction == Vector2.LEFT: anim_name = "Idle_L"
		elif mynra.player_direction == Vector2.RIGHT: anim_name = "Idle_R"
		else: anim_name = "Idle_D"
	elif !mynra.player && mynra.get_parent().name != "Oblivion":
		var player = get_tree().get_first_node_in_group("Player")
		mynra.velocity = Vector2.ZERO
		if mynra.player_direction == Vector2.LEFT: anim_name = "Idle_L"
		elif mynra.player_direction == Vector2.RIGHT: anim_name = "Idle_R"
		else: anim_name = "Idle_D"
	#else:
		#mynra.velocity = Vector2.ZERO
		#if waiting:
			#mynra_animation.pause()
		#else:
			#mynra_animation.play("Idle_L")
			#_waiting()
		
	if mynra_animation.animation != anim_name && mynra.get_parent().name != "Oblivion":
		#print(anim_name)
		mynra_animation.play(anim_name)
		#print("Current frame: ", mynra_animation.frame)

func _waiting():
	waiting = true
	await get_tree().create_timer(5).timeout
	waiting = false

#Handles transitioning between states
func _on_next_transitions() -> void:
	#Gets movement input from "Game_Input_Events" class
	#to allow the state to detect movement and change
	#states appropriately based on that
	#NOTE: For some reason, this is only necessary in the idle state
	#and if you remove it from the idle state the machine breaks, so don't
	#do that
	Game_Input_Events.movement_input()
	
	if mynra.damaged:
		transition.emit("Damaged")
	else:
		#State transitions used when this is the current player character
		if mynra.player:
			if Game_Input_Events.is_movement_input():
				transition.emit("Movement")
			elif Game_Input_Events.is_dashing():
				transition.emit("Dash")
			elif Game_Input_Events.is_prim_attacking():
				transition.emit("PrimaryAttack")
			elif Game_Input_Events.is_sec_attacking():
				transition.emit("SecondaryAttack")
		#States transitions used when this is the current companion
		elif !mynra.player && mynra.get_parent().name != "Oblivion":
			#print("I'm an NPC")
			var arlithons = get_tree().get_nodes_in_group("arlithons")
			if !arlithons.is_empty() || mynra.target_arlithon:
				transition.emit("HuntArlithons")
			elif arlithons.is_empty() && !mynra.at_player:
				transition.emit("FollowPlayer")
			elif mynra.at_player && !mynra.target_arlithon:
				transition.emit("Idle")
		else:
			return

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	mynra_animation.stop()
