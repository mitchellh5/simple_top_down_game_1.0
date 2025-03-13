extends Node

var in_range: bool = false
const FILE_BEGIN = "res://world/rath's hive/rath's_hive_"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && in_range:
		print("well I atleast attempted a transition")
		var current_scene_file = get_tree().current_scene.scene_file_path
		
		if GlobalState.scene != "Oblivion":
			if GlobalState.scene == "Rath":
				var next_level = current_scene_file.to_int() + 1
				print(FILE_BEGIN + str(next_level) + ".tscn")
				var next_level_path = FILE_BEGIN + str(next_level) + ".tscn"
				get_tree().change_scene_to_file(next_level_path)
				
			elif  GlobalState.scene ==  "Slothe":
				pass
			elif  GlobalState.scene ==  "Gluttonee":
				pass
			elif  GlobalState.scene ==  "Gried":
				pass
			elif  GlobalState.scene == "Luste":
				pass
			elif  GlobalState.scene == "Nvee":
				pass
		elif GlobalState.scene == "Oblivion" && GlobalState.ready_to_go:
			if !GlobalState.has_conquered.has("Rath"):
				var next_level_path = "res://world/rath's hive/rath's_hive_1.tscn"
				GlobalState.scene = "Rath"
				get_tree().change_scene_to_file(next_level_path)
			elif !GlobalState.has_conquered.has("Slothe"):
				pass
			elif !GlobalState.has_conquered.has("Gluttonee"):
				pass
			elif !GlobalState.has_conquered.has("Gried"):
				pass
			elif !GlobalState.has_conquered.has("Luste"):
				pass
			elif !GlobalState.has_conquered.has("Nvee"):
				pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		in_range = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		in_range = false
