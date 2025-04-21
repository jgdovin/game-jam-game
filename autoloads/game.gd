extends Node

signal word_completed(word: String)
signal typo()
signal word_fell_in_fire(word: String)
signal letter_typed(letter: String, is_valid: bool)
signal typo_mode_started()
signal typo_mode_ended()

var typo_mode: bool = false

var words_by_length: Dictionary = {}
var active_words: Array = []
var current_typing: String = ""
var current_score: int = 0

var input_buffer: String = ""
var max_input_length: int = 10

func _ready():
	load_words()

func start_typo_mode() -> void:
	typo_mode = true
	typo_mode_started.emit()

func end_typo_mode() -> void:
	typo_mode = false
	typo_mode_ended.emit()

func _unhandled_input(event):
	if typo_mode:
		return
	if event is InputEventKey and event.pressed and !event.echo:
		# Convert the keycode to a character
		var character = OS.get_keycode_string(event.keycode).to_upper()
		
		if character:
			input_buffer += character
			print("Current input buffer: ", input_buffer)
			print("Active words: ", active_words)
			# Trim the buffer to the max cheat length
			if input_buffer.length() > max_input_length:
				input_buffer = input_buffer.substr(input_buffer.length() - max_input_length, max_input_length)
			
			# Check for a valid word
			var is_valid_word: bool = false
			for word in active_words:
				print("Comparing input_buffer: '", input_buffer, "' with word: '", word, "'")
				print("Input buffer length: ", input_buffer.length(), " Word length: ", word.length())
				if input_buffer.to_upper() == word.to_upper():
					print("Exact match found!")
					# Find the Word node that matches this word and complete it
					for node in get_tree().get_nodes_in_group("words"):
						if node.word_text.to_upper() == word.to_upper():
							print("Found matching Word node")
							letter_typed.emit(character, true)
							word_completed.emit(word)
							node.complete()
							break
					remove_word_from_active(word)
					input_buffer = ""
					is_valid_word = true
					break
			
			# If no exact match, check for partial matches
			if not is_valid_word:
				var has_partial_match = false
				for word in active_words:
					if word.to_lower().begins_with(input_buffer.to_lower()):
						has_partial_match = true
						letter_typed.emit(character, true)
						print("Partial match found with: ", word)
						break
				
				# If no partial matches found, reset the buffer
				if not has_partial_match:
					typo.emit()
					letter_typed.emit(character, false)
					print("No partial matches found")
					input_buffer = ""


func load_words():
	var file = FileAccess.open("assets/words.txt", FileAccess.READ)
	if not file:
		push_error("Failed to open words.txt")
		return
		
	while file.get_position() < file.get_length():
		var word = file.get_line().strip_edges()
		word = word.trim_prefix('"').trim_suffix('"')
		if word.length() > 0:
			if not words_by_length.has(word.length()):
				words_by_length[word.length()] = []
			words_by_length[word.length()].append(word)
	
	# Sort each length group alphabetically
	for length in words_by_length:
		words_by_length[length].sort()
	
	file.close()

func get_random_word(length: int) -> String:
	if not words_by_length.has(length):
		push_error("No words of length %d" % length)
		return ""
		
	return words_by_length[length][randi() % words_by_length[length].size()]

func add_word_to_active(word: String) -> void:
	if not word in active_words:
		active_words.append(word)
		print("Added word to active: ", word)

func remove_word_from_active(word: String) -> void:
	var index = active_words.find(word)
	if index != -1:
		active_words.remove_at(index)
		print("Removed word from active: ", word)

func do_damage() -> void:
	# Clear all active words when damage is taken
	active_words.clear()
	input_buffer = ""
	print("Cleared all active words due to damage")
