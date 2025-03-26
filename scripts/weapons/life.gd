#Life
extends CharacterBody2D

const SPEED = 600 #Speed at which Famine travels
const RANGE = 300 #Range of Famine (before it begins to return to Mynra)

#Gets the character and arlithon nodes on start up to use for collision checking
@onready var character = get_tree().current_scene.find_child("PlayerScythio")
@onready var arlithon = get_tree().get_first_node_in_group("Arlithons")

#Variables used to make sure Famine is thrown the direction that Mynra
#is facing ("rot" and "dir") and from where she is in the scene ("pos")
var dir: Vector2

var collectable: bool = false 	#Makes sure it's collection status remains synced with Mynra's to avoid issues of duplication or entirely deleting Famine from the scene
var distance_travelled = 0		#Tracks how far Famine has traveled from Mynra

#Runs at start up (when Famine is thrown by Mynra)
func _ready():
	#Starts timer (0.05s) to track when it is okay to return to Mynra
	$Timer.start()
	collectable = false

func aim_famine(position, target_pos):
	global_position = position
	dir = (target_pos - position).normalized()
	rotation_degrees = rad_to_deg(position.angle_to_point(target_pos))

#Runs every frame (after being thrown by Mynra)
func _physics_process(delta: float) -> void:
	
	#Tracks how far Famine has traveled in reference to its range
	#and begins returning to Mynra once it has surpassed its range
	distance_travelled += SPEED * delta
	if distance_travelled > RANGE:
		pass
	
	#As long as Famine hasn't exceeded its range, it will continue
	#to travel across the scene in the direction it was thrown
	if distance_travelled <= RANGE:
		position += dir * SPEED * delta
		move_and_slide()
	else:
		return_to_mynra()

#Once the timer (0.05s) has ended, it marks Famine as "collectable"
func _on_timer_timeout() -> void:
	collectable = true
	#print("Famine is now collectable!")

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	#When famine collides with Mynra, as long as it is marked as collectable
	#It frees itself from the queue and signals to Mynra that it has been collected
	#print("Attempted to be collected")
	print(collectable)
	print(character)
	if collectable:
		print("Famine has returned to Mynra")
		queue_free()
		print("Life has returned to Scythio")
	
	#When Famine hits an arlithon, it signals to the arlithon to take
	#damage, then begins to return to Mynra if it's collectable
	elif body.has_method("take_damage"):
		body.take_damage()
	
	elif body.is_in_group("walls"):
		pass

#This function is used to have Famine track back towards Mynra for collection
func return_to_mynra():
	var direction = global_position.direction_to(character.global_position)
	velocity = direction * SPEED
	move_and_slide()
