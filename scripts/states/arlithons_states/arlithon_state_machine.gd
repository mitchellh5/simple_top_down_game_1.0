#Arlithon_State_Machine
class_name Arlithon_State_Machine
extends Node

@export var initial_arlithon_state : Arlithon_State	#Defines default state for the state machine to begin as

var arlithon_states : Dictionary = {}				#States dictionary
var current_arlithon_state : Arlithon_State		#Tracks current state
var current_arlithon_state_name : String		#Holds name of current state

#Runs on startup
func _ready():
	for child in get_children():							#Loops over all children
		if child is Arlithon_State:							#If current child is a state
			arlithon_states[child.name.to_lower()] = child	#Add it to the dictionary "states" using its name (NOTE: uses "to_lower" to avoid issues with case sensitivity
			child.transition.connect(transition_to)
	
	if initial_arlithon_state:					#Checks if there is an "initial_state"
		#initial_player_state.player = get_parent()
		initial_arlithon_state._on_enter()			#If so, enters "initial_state"
		current_arlithon_state = initial_arlithon_state	#And sets the "current_state" equal to "initial_state"

#Updates every frame, similarly to "_physics_process," but without a set frame rate
#(Typically 60 fps for "_physics_process")
func _process(delta: float) -> void:
	#Checks if we have a current state, and runs "Update" if so
	if current_arlithon_state:
		current_arlithon_state._on_update(delta)

#Updates every frame
func _physics_process(delta: float) -> void:
	#Checks if we have a current state, and runs "Physics_Update" if so
	if current_arlithon_state:
		current_arlithon_state._on_physics_update(delta)
		current_arlithon_state._on_next_transitions()

func transition_to(arlithon_state_name: String) -> void:
	if arlithon_state_name == current_arlithon_state_name.to_lower():
		return
	
	var new_arlithon_state = arlithon_states.get(arlithon_state_name.to_lower())
	
	if !new_arlithon_state:
		return
	
	if current_arlithon_state:
		current_arlithon_state._on_exit()
	
	current_arlithon_state = new_arlithon_state
	current_arlithon_state_name = current_arlithon_state.name.to_lower()
	
	# *** IMPORTANT: Call _on_enter() on the new state ***
	current_arlithon_state._on_enter()
	#print("Current State: ", current_arlithon_state)
