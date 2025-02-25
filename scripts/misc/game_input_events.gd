#Game_Input_Events
class_name Game_Input_Events

static var direction: Vector2		#Tracks cardinal directions
static var input_vector: Vector2	#Tracks all 8 directions

#Used to detect movement input from player, returning the cardinal direction for animation purposes
static func movement_input() -> Vector2:
	if Input.is_action_pressed("move_left"): direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"): direction = Vector2.RIGHT
	elif Input.is_action_pressed("move_up"): direction = Vector2.UP
	elif Input.is_action_pressed("move_down"): direction = Vector2.DOWN
	else: direction = Vector2.ZERO
	
	return direction

#Used to handle movement of player and returns the overall input vector
static func velocity_of_movement() -> Vector2:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	print(input_vector)
	return input_vector

#Detects player movement (specifically basic movement)
static func is_movement_input() -> bool:
	if direction == Vector2.ZERO:
		return false
	else:
		return true

#Detects if player is currently dashing
static func is_dashing() -> bool:
	if Input.is_action_just_pressed("dash"):
		return true
	else:
		return false

#Detects if player is currently using their secondary attack
static func is_sec_attacking() -> bool:
	if Input.is_action_just_pressed("secondary_attack"):
		return true
	else:
		return false

#Detects if player is currently using their primary attack
static func is_prim_attacking() -> bool:
	if Input.is_action_just_pressed("primary_attack"):
		return true
	else:
		return false
