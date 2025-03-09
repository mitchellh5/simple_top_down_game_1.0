extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $DisplayTimer

const MAX_WIDTH = 500

var text = ""				#Variable for storing the text that will be displayed
var character_index = 0		#Index between each letter (duh)

#How much time between each letter, space, and punctutation is printed into the text box
var letter_time = 0.025
var space_time = 0.02
var punctuation_time = 0.02

#Goes off when the text is done being displayed
signal finished_displaying()

#Function that actually handles displaying the text to the screen
func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display
	
	#Waits to display the text until the textbox has resized itself for it
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)				#Sets up minimum x size of label (set as from current size to MAX_WIDTH
	
	#If it exceeds the max width, it adds a new line for the text
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized									#waits for x to resize
		await resized									#waits for y to resize
		custom_minimum_size.y  = size.y					#new minimum y size
	
	#Sets the position for the display (centered on the x-axis and just above the speaker)
	global_position.x -= size.x/2
	global_position.y -= size.y - 150
	
	label.text = ""
	_display_character()

#Adds the text to the textbox character by character
func _display_character():
	label.text += text[character_index]			#Appends one character the current character index
	character_index += 1							#then increments the character index (it's literally like how wrote strings in C)
	
	#Checks if we have already displayed all character for the text, and if
	#so, signals that the text is done being displayed and returns nothing
	if character_index >= text.length():
		finished_displaying.emit()
		return
	
	#Checks each character to see what is being displayed
	#to time the printing of the character appropriately
	match text[character_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)

func _on_display_timer_timeout() -> void:
	_display_character()
