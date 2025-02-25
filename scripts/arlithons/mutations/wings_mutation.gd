extends CharacterBody2D

@onready var parent_arlithon: PackedScene = preload("res://scenes/arlithons/arlithon.tscn")


func _physics_process(delta: float) -> void:
	if get_parent().velocity.x < 0:
		$Wings.flip_h = false
	else:
		$Wings.flip_h = true
