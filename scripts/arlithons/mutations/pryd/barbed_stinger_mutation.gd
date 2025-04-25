extends CharacterBody2D

@onready var parent_arlithon: PackedScene = preload("res://scenes/arlithons/Pryd's_Basic.tscn")

func _physics_process(delta: float) -> void:
	if get_parent().velocity.x < 0:
		$Barbed_Stinger.flip_h = false
	else:
		$Barbed_Stinger.flip_h = true
