#Life
extends CharacterBody2D

const SPEED = 600 #Speed at which Life travels
const RANGE = 300 #Range of Life (before it begins to return to Scythio)

#Gets the character and arlithon nodes on start up to use for collision checking
@onready var character = get_tree().current_scene.find_child("PlayerScythio")
@onready var arlithon = get_tree().get_first_node_in_group("Arlithons")

#Variables used to make sure Life is thrown the direction that Scythio
#is facing ("rot" and "dir") and from where she is in the scene ("pos")
var dir: Vector2

var collectable: bool = false 	#Makes sure it's collection status remains synced with Scythio's to avoid issues of duplication or entirely deleting Life from the scene
var distance_travelled = 0		#Tracks how far Life has traveled from Scythio
var returning: bool = false		#Tells Life when it is time to start returning to Scythio

#Runs at start up (when Life is thrown by Scythio)
func _ready():
	#Starts timer (0.05s) to track when it is okay to return to Scythio
	$Timer.start()

func aim_life(position, target_pos):
	global_position = position
	dir = (target_pos - position).normalized()
	rotation_degrees = rad_to_deg(position.angle_to_point(target_pos))

#Runs every frame (after being thrown by Scythio)
func _physics_process(delta: float) -> void:
	
	#Tracks how far Life has traveled in reference to its range
	#and begins returning to Scythio once it has surpassed its range
	rotation += PI/4
	distance_travelled += SPEED * delta
	if distance_travelled > RANGE:
		#print("Maximum distance traveled.")
		returning = true
	
	#As long as Life hasn't exceeded its range, it will continue
	#to travel across the scene in the direction it was thrown
	if returning == false:
		position += dir * SPEED * delta
		move_and_slide()
	else:
		return_to_scythio()		#Runs the "return_to_scythio()" function once Life has exceeded its range of attack

#Once the timer (0.05s) has ended, it marks Life as "collectable"
func _on_timer_timeout():
	collectable = true
	#print("Life is now collectable!")

#Checks collisions Life has with characters, enemies, and walls
func _on_area_2d_body_entered(body):
	
	#When Life collides with Scythio, as long as it is marked as collectable
	#It frees itself from the queue and signals to Scythio that it has been collected
	if body == character && collectable == true:
		#print("Life has returned to Scythio")
		queue_free()
		if body.has_method("collect_life"):
			body.collect_life()
	
	#When Life hits an arlithon, it signals to the arlithon to take
	#damage, then begins to return to Scythio if it's collectable
	elif body.has_method("take_damage"):
		body.take_damage()
		
		#Life makes sure that it is collectable before returning to Scythio. If it isn't,
		#it waits for 0.07s, then returns to Scythio since by then it will be collectable.
		#This exists to avoid issues in cases where the player is throwing Life at an
		#arlithon or wall at point-blank range
		if collectable == true:
			returning = true
		else:
			await get_tree().create_timer(0.07).timeout
			returning = true
	
	elif body.is_in_group("walls"):
		if collectable == true:
			returning = true
		else:
			await get_tree().create_timer(0.07).timeout
			returning = true

#This function is used to have Life track back towards Scythio for collection
func return_to_scythio():
	var direction = global_position.direction_to(character.global_position)
	velocity = direction * SPEED
	move_and_slide()
