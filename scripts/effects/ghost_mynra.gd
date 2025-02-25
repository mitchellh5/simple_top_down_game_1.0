#Basic script for ghost effect for Mynra
#(can easily be copied for ghosts of future characters, only necessary change is animation sprite sheet)
extends AnimatedSprite2D

func _ready():
	ghosting()

func set_property(x_pos, x_scale):
	position = x_pos
	scale = x_scale

func ghosting():
	var tween_fade = get_tree().create_tween()
	
	tween_fade.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.75)
	await tween_fade.finished
	
	queue_free()
