#Player_State_Machine
class_name MynraStateMachine
extends Node

@export var initial_mynra_state : MynraState	#Defines default state for the state machine to begin as

var mynra_states : Dictionary = {}				#States dictionary
var current_mynra_state : MynraState		#Tracks current state
var current_mynra_state_name : String		#Holds name of current state

func _ready():
	#print("Children of State Machine:")
	for child in get_children():
		#print("- ", child.name, " (", child.get_class(), ")")
		if child is MynraState:
			#print("  -> This is a MynraState")
			mynra_states[child.name.to_lower()] = child
			child.transition.connect(transition_to)

	if initial_mynra_state:
		var state_name := initial_mynra_state.name.to_lower()
		#print("Initial state set in Inspector: ", state_name)
		var true_initial_state = mynra_states.get(state_name)

		if true_initial_state:
			current_mynra_state = true_initial_state
			current_mynra_state_name = state_name
			call_deferred("_enter_initial_state")
		else:
			push_error("Initial state '%s' not found in children!" % state_name)

func _enter_initial_state():
	current_mynra_state._on_enter()

#Updates every frame, similarly to "_physics_process," but without a set frame rate
#(Typically 60 fps for "_physics_process")
func _process(delta: float) -> void:
	#Checks if we have a current state, and runs "Update" if so
	if current_mynra_state:
		current_mynra_state._on_update(delta)

#Updates every frame
func _physics_process(delta: float) -> void:
	#Checks if we have a current state, and runs "Physics_Update" if so
	if current_mynra_state:
		current_mynra_state._on_physics_update(delta)
		current_mynra_state._on_next_transitions()

func transition_to(mynra_state_name: String) -> void:
	if mynra_state_name == current_mynra_state_name.to_lower():
		return
	
	var new_mynra_state = mynra_states.get(mynra_state_name.to_lower())
	
	if !new_mynra_state:
		return
	
	if current_mynra_state:
		current_mynra_state._on_exit()
	
	current_mynra_state = new_mynra_state
	current_mynra_state_name = current_mynra_state.name.to_lower()
	
	current_mynra_state._on_enter()
	
	#print("Current State: ", current_mynra_state_name)
