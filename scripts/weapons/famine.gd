#Famine
extends CharacterBody2D

const SPEED = 600 #Speed at which Famine travels
const RANGE = 300 #Range of Famine (before it begins to return to Mynra)

#Gets the character and arlithon nodes on start up to use for collision checking
@onready var character = get_tree().current_scene.find_child("PlayerMynra")
@onready var arlithon = get_tree().get_first_node_in_group("Arlithons")

#Variables used to make sure Famine is thrown the direction that Mynra
#is facing ("rot" and "dir") and from where she is in the scene ("pos")
var dir: Vector2

var collectable: bool = false 	#Makes sure it's collection status remains synced with Mynra's to avoid issues of duplication or entirely deleting Famine from the scene
var distance_travelled = 0		#Tracks how far Famine has traveled from Mynra
var returning: bool = false		#Tells Famine when it is time to start returning to Mynra

#Runs at start up (when Famine is thrown by Mynra)
func _ready():
	#Starts timer (0.05s) to track when it is okay to return to Mynra
	$Timer.start()

func aim_famine(position, target_pos):
	global_position = position
	dir = (target_pos - position).normalized()
	rotation_degrees = rad_to_deg(position.angle_to_point(target_pos))

#Runs every frame (after being thrown by Mynra)
func _physics_process(delta: float) -> void:
	
	#Tracks how far Famine has traveled in reference to its range
	#and begins returning to Mynra once it has surpassed its range
	rotation += PI/4
	distance_travelled += SPEED * delta
	if distance_travelled > RANGE:
		#print("Maximum distance traveled.")
		returning = true
	
	#As long as Famine hasn't exceeded its range, it will continue
	#to travel across the scene in the direction it was thrown
	if returning == false:
		position += dir * SPEED * delta
		move_and_slide()
	else:
		return_to_mynra()	#Runs the "return_to_mynra()" function once Famine has exceeded its range of attack

#Once the timer (0.05s) has ended, it marks Famine as "collectable"
func _on_timer_timeout():
	collectable = true
	#print("Famine is now collectable!")

#Checks collisions Famine has with characters, enemies, and walls
func _on_area_2d_body_entered(body):
	
	#When famine collides with Mynra, as long as it is marked as collectable
	#It frees itself from the queue and signals to Mynra that it has been collected
	if body == character && collectable == true:
		#print("Famine has returned to Mynra")
		queue_free()
		if body.has_method("collect_famine"):
			body.collect_famine()
	
	#When Famine hits an arlithon, it signals to the arlithon to take
	#damage, then begins to return to Mynra if it's collectable
	elif body.has_method("take_damage"):
		print("Hit an arlithon")
		body.take_damage()
		
		#Famine makes sure that it is collectable before returning to Mynra. If it isn't,
		#it waits for 0.07s, then returns to Mynra since by then it will be collectable.
		#This exists to avoid issues in cases where the player is throwing Famine at an
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

#This function is used to have Famine track back towards Mynra for collection
func return_to_mynra():
	var direction = global_position.direction_to(character.global_position)
	velocity = direction * SPEED
	move_and_slide()
