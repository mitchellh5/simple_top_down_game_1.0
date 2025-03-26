#ScythioStateMachine
class_name ScythioStateMachine
extends Node

@export var initial_scythio_state : ScythioState	#Defines default state for the state machine to begin as

var scythio_states : Dictionary = {}				#States dictionary
var current_scythio_state : ScythioState		#Tracks current state
var current_scythio_state_name : String		#Holds name of current state

#Runs on startup
func _ready():
	for child in get_children():							#Loops over all children
		if child is ScythioState:							#If current child is a state
			scythio_states[child.name.to_lower()] = child	#Add it to the dictionary "states" using its name (NOTE: uses "to_lower" to avoid issues with case sensitivity
			child.transition.connect(transition_to)
	
	if initial_scythio_state:					#Checks if there is an "initial_state"
		#initial_player_state.player = get_parent()
		initial_scythio_state._on_enter()			#If so, enters "initial_state"
		current_scythio_state = initial_scythio_state	#And sets the "current_state" equal to "initial_state"

#Updates every frame, similarly to "_physics_process," but without a set frame rate
#(Typically 60 fps for "_physics_process")
func _process(delta: float) -> void:
	#Checks if we have a current state, and runs "Update" if so
	if current_scythio_state:
		current_scythio_state._on_update(delta)

#Updates every frame
func _physics_process(delta: float) -> void:
	#Checks if we have a current state, and runs "Physics_Update" if so
	if current_scythio_state:
		current_scythio_state._on_physics_update(delta)
		current_scythio_state._on_next_transitions()

func transition_to(scythio_state_name: String) -> void:
	if scythio_state_name == current_scythio_state_name.to_lower():
		return
	
	var new_scythio_state = scythio_states.get(scythio_state_name.to_lower())
	
	if !new_scythio_state:
		return
	
	if current_scythio_state:
		current_scythio_state._on_exit()
	
	current_scythio_state = new_scythio_state
	current_scythio_state_name = current_scythio_state.name.to_lower()
	print("Current State: ", current_scythio_state_name)
