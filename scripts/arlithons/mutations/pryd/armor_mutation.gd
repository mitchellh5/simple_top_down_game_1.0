extends CharacterBody2D

@onready var parent_arlithon: PackedScene = preload("res://scenes/arlithons/Pryd's_Basic.tscn")

var hatched: bool = false

func _physics_process(delta: float) -> void:
	if !hatched:
		if get_parent().velocity.x < 0:
			$Hatchling.flip_h = false
		else:
			$Hatchling.flip_h = true
