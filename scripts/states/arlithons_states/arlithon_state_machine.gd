# Arlithon_State_Machine
class_name Arlithon_State_Machine
extends Node

@export var initial_arlithon_state : Arlithon_State	#Defines default state for the state machine to begin as

var arlithon_states : Dictionary = {}				#States dictionary
var current_arlithon_state : Arlithon_State		#Tracks current state
var current_arlithon_state_name : String		#Holds name of current state

func _ready():
	#print("Children of State Machine:")
	for child in get_children():
		#print("- ", child.name, " (", child.get_class(), ")")
		if child is Arlithon_State:
			#print("  -> This is an Arlithon_State")
			arlithon_states[child.name.to_lower()] = child
			child.transition.connect(transition_to)

	if initial_arlithon_state:
		var state_name := initial_arlithon_state.name.to_lower()
		#print("Initial state set in Inspector: ", state_name)
		var true_initial_state = arlithon_states.get(state_name)

		if true_initial_state:
			current_arlithon_state = true_initial_state
			current_arlithon_state_name = state_name
			call_deferred("_enter_initial_state")
		else:
			push_error("Initial state '%s' not found in children!" % state_name)

func _enter_initial_state():
	current_arlithon_state._on_enter()

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
	
	current_arlithon_state._on_enter()
	
	#print("Current State: ", current_arlithon_state_name)
