extends CharacterBody2D

@onready var parent_arlithon: PackedScene = preload("res://scenes/arlithons/Pryd's_Basic.tscn")

func _physics_process(delta: float) -> void:
	if get_parent().velocity.x < 0:
		$Armor.flip_h = false
	else:
		$Armor.flip_h = true
