#Player_State_Machine
class_name MynraStateMachine
extends Node

@export var initial_mynra_state : MynraState	#Defines default state for the state machine to begin as

var mynra_states : Dictionary = {}				#States dictionary
var current_mynra_state : MynraState		#Tracks current state
var current_mynra_state_name : String		#Holds name of current state

#Runs on startup
func _ready():
	for child in get_children():							#Loops over all children
		if child is MynraState:							#If current child is a state
			mynra_states[child.name.to_lower()] = child	#Add it to the dictionary "states" using its name (NOTE: uses "to_lower" to avoid issues with case sensitivity
			child.transition.connect(transition_to)
	
	if initial_mynra_state:					#Checks if there is an "initial_state"
		#initial_player_state.player = get_parent()
		initial_mynra_state._on_enter()			#If so, enters "initial_state"
		current_mynra_state = initial_mynra_state	#And sets the "current_state" equal to "initial_state"

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
	#print("Current State: ", current_mynra_state_name)
