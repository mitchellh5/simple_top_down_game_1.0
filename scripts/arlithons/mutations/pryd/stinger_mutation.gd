extends CharacterBody2D

@export var sprite: AnimatedSprite2D
@onready var parent = get_parent()

var has_grown: bool = false

func _ready() -> void:
	if parent.has_signal("direction_changed"):
		parent.connect("direction_changed", Callable(self, "_on_direction_changed"))
	
	if parent.has_signal("modulating"):
		parent.connect("modulating", Callable(self, "_on_damaged"))

func _physics_process(delta: float) -> void:
	
	if !has_grown:
		sprite.play("Grow_Shrink")
		has_grown = true
	
	if get_parent().health <= 0:
		_death()
	elif parent.body_in_atk_range && !parent.stunlocked && !sprite.is_playing():
		_atk()
	elif !sprite.is_playing():
		sprite.play("Idle")

func _atk():
	sprite.play("Atk")

func _death():
	#$Stinger.flip_h = false
	sprite.play("Death")

func _on_direction_changed(flip_h: bool) -> void:
	$Stinger.flip_h = flip_h

func _on_damaged(red: bool) -> void:
	if red:
		$Stinger.modulate = Color.RED
	else:
		$Stinger.modulate = Color.WHITE
