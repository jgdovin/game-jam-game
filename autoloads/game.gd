extends Node
var alphabet: Array[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var emojis: Array[String] = ["😊", "😒", "👍", "🙌", "💖", "😎", "😂", "😅", "😍", "🥲", "🤩", "😶‍🌫️", "🤑", "🫠", "🤯", "😭", "😷", "🥳", "💩", "😺", "🦝", "🐮", "🦜", "🦉", "⛷️", "🎊", "🎉", "🍕", "🍔", "🍿", "❤️", "💙", "💚", "💛", "🧡", "🩷"]

signal word_completed(word: String)
signal typo(typos_made: int)
signal word_fell_in_fire(word: String)
signal letter_typed(letter: String, is_valid: bool)
signal typo_mode_started()
signal typo_mode_ended()
signal score_changed(new_score: int)
signal game_started()
signal game_ended()
signal damage_taken()
signal difficulty_increased()
signal emojis_updated(emojis: String)

var typo_mode: bool = false

var words_by_length: Dictionary = {}
var active_words: Array = []
var current_typing: String = ""

var input_buffer: String = ""
var max_input_length: int = 10

var game_active: bool = false

var current_score: int = 0
var typos_made: int = 0
var typo_modes_triggered: int = 0
var words_completed: int = 0
var words_in_fire: int = 0
var letters_typed: int = 0

var difficulty: int = 1

var player_emojis: String = ""

func _ready():
	load_words()
	letter_typed.connect(_on_letter_typed)
	word_completed.connect(_on_word_completed)
	word_fell_in_fire.connect(_on_word_fell_in_fire)
	for i in 5:
		player_emojis += emojis[randi() % emojis.size()]
	emojis_updated.emit(player_emojis)
	typo_mode_started.connect(_on_typo_mode_started)

func _on_typo_mode_started() -> void:
	typo_modes_triggered += 1

func _on_letter_typed(_letter: String, _is_valid: bool) -> void:
	letters_typed += 1

func _on_word_completed(_word: String) -> void:
	words_completed += 1
	if words_completed % 10 == 0:
		difficulty += 1
		difficulty_increased.emit()
func _on_word_fell_in_fire(_word: String) -> void:
	words_in_fire += 1

func start_game() -> void:
	_reset_game_state()
	game_active = true
	SoundManager.play_game_music()
	game_started.emit()

func _reset_game_state() -> void:
	game_active = false
	current_score = 0
	typos_made = 0
	active_words.clear()
	input_buffer = ""
	current_typing = ""
	letters_typed = 0
	words_completed = 0
	words_in_fire = 0
	difficulty = 1
	typo_modes_triggered = 0
	score_changed.emit(current_score)

func end_game() -> void:
	game_active = false
	References.game_controller.load_summary()
	await Leaderboards.post_guest_score(References.quiver_leaderboard_id, Game.current_score, player_emojis, {"difficulty": Game.difficulty, "words_completed": Game.words_completed, "words_lost": Game.words_in_fire, "typos_made": Game.typos_made, "typo_modes_triggered": Game.typo_modes_triggered})
	game_ended.emit()


func clear_game_state() -> void:
	active_words.clear()
	input_buffer = ""
	current_typing = ""
	current_score = 0

func increase_score(amount: int) -> void:
	current_score += amount
	score_changed.emit(current_score)

func decrease_score(amount: int) -> void:
	current_score -= amount
	score_changed.emit(current_score)
	damage_taken.emit()

func start_typo_mode() -> void:
	typo_mode = true
	typo_mode_started.emit()

func end_typo_mode() -> void:
	typo_mode = false
	typo_mode_ended.emit()

func _unhandled_input(event):
	if typo_mode or not game_active:
		return
	if event is InputEventKey and event.pressed and !event.echo:
		# Convert the keycode to a character
		var character = OS.get_keycode_string(event.keycode).to_upper()
		if not character in alphabet:
			return
		if character in alphabet:
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
					typo.emit(typos_made)
					typos_made += 1
					References.health.take_damage(2)
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
	print("Loaded words: ", words_by_length.keys())

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
