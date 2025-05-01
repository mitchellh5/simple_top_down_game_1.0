#active_characters.gd
extends Node

#Stores all characters currently active in the scene
#ie: in the Prelude this will see Mynra and Scythio
var active_characters: Array[CharacterBody2D] = []

# Returns the currently controlled character (e.g. index 0)
func get_primary_character() -> CharacterBody2D:
	if active_characters.size() > 0:
		return active_characters[0]
	return null

# Optionally return second one
func get_secondary_character() -> CharacterBody2D:
	if active_characters.size() > 1:
		return active_characters[1]
	return null

# Call this when loading levels or switching characters
func set_active_characters(chars: Array[CharacterBody2D]) -> void:
	active_characters = chars
