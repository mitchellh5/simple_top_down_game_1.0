extends Node

var in_range: bool = false
const PRYDS_SUBHIVE = "res://world/pryd's subhive/pryd's_subhive_"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && in_range:
		#print("well I atleast attempted a transition")
		var current_scene_file = get_tree().current_scene.scene_file_path
		
		if GlobalState.scene != "Oblivion":
			if GlobalState.scene == "Pryd's Subhive":
				var next_level = current_scene_file.to_int() + 1
				var next_level_path = PRYDS_SUBHIVE + str(next_level) + ".tscn"
				get_tree().change_scene_to_file(next_level_path)
			elif GlobalState.scene == "Rath":
				pass
			elif  GlobalState.scene ==  "Slothe":
				pass
			elif  GlobalState.scene ==  "Gluttonee":
				pass
			elif  GlobalState.scene ==  "Gried":
				pass
			elif  GlobalState.scene == "Lustt":
				pass
			elif  GlobalState.scene == "Nvee":
				pass
		elif GlobalState.scene == "Oblivion" && GlobalState.ready_to_go:
			if GlobalState.sun == "Prelude":
				var next_level_path = "res://world/pryd's subhive/pryd's_subhive_1.tscn"
				GlobalState.scene = "Pryd's Subhive"
				get_tree().change_scene_to_file(next_level_path)
			elif !GlobalState.has_conquered.has("Rath"):
				pass
			elif !GlobalState.has_conquered.has("Slothe"):
				pass
			elif !GlobalState.has_conquered.has("Gluttonee"):
				pass
			elif !GlobalState.has_conquered.has("Gried"):
				pass
			elif !GlobalState.has_conquered.has("Lustt"):
				pass
			elif !GlobalState.has_conquered.has("Nvee"):
				pass

func _on_body_entered(body: Node2D) -> void:
	#print("Body entered:", body.name, "; on layer(s):", body.collision_layer)
	if body.is_in_group("Player"):
		in_range = true

func _on_body_exited(body: Node2D) -> void:
	#print("Body exited:", body.name)
	if body.is_in_group("Player"):
		in_range = false
