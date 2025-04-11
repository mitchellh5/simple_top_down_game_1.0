extends CharacterBody2D

@onready var parent_arlithon: PackedScene = preload("res://scenes/arlithons/Rath's_Basic.tscn")

func _physics_process(delta: float) -> void:
	if get_parent().velocity.x < 0:
		$Tail.flip_h = false
	else:
		$Tail.flip_h = true
