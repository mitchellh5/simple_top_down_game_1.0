#Idle
extends ScythioState

@export var scythio : PlayerScythio
@export var scythio_animation : AnimatedSprite2D

#Runs every frame
func _on_update(_delta: float) -> void:
	pass

#Runs every frame
func _on_physics_update(_delta: float) -> void:
	#Plays the proper animation based on the direction the player was facing
	#when they entered the state (NOTE: there are no "Idle_U" animations)
	var anim_name : String
	
	if scythio.player:
		if scythio.player_direction == Vector2.LEFT: anim_name = "Idle_L"
		elif scythio.player_direction == Vector2.RIGHT: anim_name = "Idle_R"
		else: anim_name = "Idle_D"
	elif !scythio.player && scythio.get_parent().name != "Oblivion":
		var player = get_tree().get_first_node_in_group("Player")
		scythio.velocity = Vector2.ZERO
		if player.player_direction == Vector2.LEFT: anim_name = "Idle_L"
		elif player.player_direction == Vector2.RIGHT: anim_name = "Idle_R"
		else: anim_name = "Idle_D"
	else:
		scythio.velocity = Vector2.ZERO
		anim_name = "Idle_L"
		
	if scythio_animation.animation != anim_name:
		#print(anim_name)
		scythio_animation.play(anim_name)
		#print("Current frame: ", scythio_animation.frame)

#Handles transitioning between states
func _on_next_transitions() -> void:
	#Gets movement input from "Game_Input_Events" class
	#to allow the state to detect movement and change
	#states appropriately based on that
	#NOTE: For some reason, this is only necessary in the idle state
	#and if you remove it from the idle state the machine breaks, so don't
	#do that
	Game_Input_Events.movement_input()
	if scythio.damaged:
		transition.emit("Damaged")
	else:
		#State transitions used when this is the current player character
		if scythio.player:
			if Game_Input_Events.is_movement_input():
				transition.emit("Movement")
			elif Game_Input_Events.is_dashing():
				transition.emit("Dash")
			elif Game_Input_Events.is_prim_attacking():
				transition.emit("Primary_Attack")
			elif Game_Input_Events.is_sec_attacking():
				transition.emit("Secondary_Attack")
		#States transitions used when this is the current companion
		elif !scythio.player && scythio.get_parent().name != "Oblivion":
			print(scythio.get_parent().name)
			var arlithons = get_tree().get_nodes_in_group("arlithons")
			if !arlithons.is_empty():
				transition.emit("HuntArlithons")
			elif arlithons.is_empty() && !scythio.at_player:
				transition.emit("FollowPlayer")
			elif scythio.at_player:
				transition.emit("Idle")

#Runs upon entering state
func _on_enter():
	pass

#Runs upon exiting state
func _on_exit():
	scythio_animation.stop()
