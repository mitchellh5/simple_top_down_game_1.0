extends Node

@onready var text_box_scene = preload("res://ui/Textboxes/ScythiosTextBox.tscn")

var dialogue_lines: Array[String] = []
var current_line_index = 0

var text_box
var text_box_pos

var dialogue_active = false
var advance_line = false

#Function that initiates the dialogue
func start_dialogue(position: Vector2, lines: Array[String]):
	#If there is dialogue already active, it will return nothing
	#to avoid interrupting what is currently being displayed
	if dialogue_active:
		return
	
	#Sets "dialogue_lines" to the "lines" var, and "text_box_pos"
	#to "position" then runs the "_show_text_box()" function
	dialogue_lines = lines
	text_box_pos = position
	_show_text_box()
	
	#Sets "dialogue_active" to true so that it isn't interrupted by other dialogue
	dialogue_active = true

#Instantiates the "text_box" to be displayed on screen in the current main scene and begins printing the current line of text
func _show_text_box():
	text_box = text_box_scene.instantiate()										#Instantiates the "text_box_scene" scene into the current scene
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)		#Awaits the "finished_displaying" signal from the "text_box" scene then runs
																				#the "_on_text_box_finished_displaying" function to prevent it from advancing
																				#the next line until the current line of text has finished printing
																				
	get_tree().root.add_child(text_box)											#Adds the "text_box" as a child to the current main scene
	text_box.global_position = text_box_pos										#Sets the global position of the "text_box" to the pos set up in the "text_box_scene" scene
	text_box.display_text(dialogue_lines[current_line_index])					#Begins displaying the dialogue text to the screen on the "current_line_index"
	advance_line = false														#Prevents it from advancing lines as it prints the current line of text

#Prevents the "text_box" from advancing to the next line while printing until it has finished printing the current line of text
func _on_text_box_finished_displaying():
	advance_line = true

#Waits for the player to advance the dialogue once they have finished reading what is currently being displayed
func _unhandled_input(event):
	if(
		event.is_action_pressed("advance_dialogue") &&
		dialogue_active &&
		advance_line
	):
		text_box.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialogue_lines.size():
			dialogue_active = false
			current_line_index = 0
			return
		
		_show_text_box()
