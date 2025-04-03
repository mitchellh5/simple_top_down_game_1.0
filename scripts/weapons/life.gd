#Life
extends RigidBody2D

@onready var collection_area = $CollectionArea

const SPEED = 1200

#Variables used to make sure Famine is thrown the direction that Mynra
#is facing ("rot" and "dir") and from where she is in the scene ("pos")
var dir: Vector2

var collectable: bool = false		#Makes sure it's collection status remains synced with Mynra's to avoid issues of duplication or entirely deleting Famine from the scene
var distance_travelled = 0			#Tracks how far Famine has traveled from Mynra
var returning: bool = false			#Tells Famine when it is time to start returning to Mynra
var scythio: CharacterBody2D

func _ready() -> void:
	scythio = get_tree().get_first_node_in_group("Scythio")
	contact_monitor = true
	max_contacts_reported = 1
	$Timer.start()

func launch(direction: Vector2):
	dir = direction.normalized()  # Ensure direction is a unit vector
	linear_velocity = dir * SPEED  # Apply initial velocity

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	for contact in state.get_contact_count():
		var collider = state.get_contact_collider_object(contact)
		
		#Stops Life from moving once it has hit an enemy or a wall
		if collider.is_in_group("walls") || collider.is_in_group("Arlithons"):
			if collider.has_method("take_damage") && !freeze:
				collider.take_damage()
			freeze = true
			linear_velocity = Vector2.ZERO

#func _life_collected():
	#if collectable:
		#queue_free()

func _on_collection_area_area_entered(area: Node2D) ->void:
	if area.get_parent().has_method("collect_life") && collectable:
		area.get_parent().collect_life()
		print("I has been grabbed!")
		queue_free()

#func _on_collection_area_body_entered(body: Node2D) -> void:
	#print("Scythio's grabbing me")
	#if body.has_method("collect_life") && collectable:
		#print("I has been grabbed!")
		#body.collect_life()
		#queue_free()

func aim_life(position, target_pos):
	global_position = position
	dir = (target_pos - position).normalized()
	rotation_degrees = rad_to_deg(position.angle_to_point(target_pos))
	launch(dir)

func _on_timer_timeout():
	collectable = true
	#print("Life is now collectable!")
