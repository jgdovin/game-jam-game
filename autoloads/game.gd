extends Node
var alphabet: Array[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

signal word_completed(word: String)
signal partical_match_found(word: String)
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

var current_typing: String = ""

var input_buffer: String = ""

var game_active: bool = false

var current_streak: int = 0
var max_streak: int = 0
var difficulty_streak: int = 0

var current_score: int = 0
var typos_made: int = 0
var typo_modes_triggered: int = 0
var words_completed: int = 0
var words_in_fire: int = 0
var letters_typed: int = 0

var difficulty: int = 1

var player_emojis: String = ""

var active_words: Array = []

func _ready():
	connect_signals()

	for i in 5:
		player_emojis += str(randi() % 30)
	print("Player emojis: ", player_emojis)
	emojis_updated.emit(player_emojis)

func connect_signals() -> void:
	letter_typed.connect(_on_letter_typed)
	word_completed.connect(_on_word_completed)
	word_fell_in_fire.connect(_on_word_fell_in_fire)
	typo_mode_started.connect(_on_typo_mode_started)

func get_streak_to_next_difficulty() -> int:
	return diff_formula(difficulty) - difficulty_streak + 1

func diff_formula(curr_difficulty: int) -> int:
	return curr_difficulty * 2 + curr_difficulty

func start_game() -> void:
	_reset_game_state()
	game_active = true
	SoundManager.play_game_music()
	game_started.emit()


func end_game() -> void:
	game_active = false
	References.game_controller.load_leaderboard()
	await Leaderboards.post_guest_score(References.quiver_leaderboard_id, Game.current_score, player_emojis, {"difficulty": Game.difficulty, "words_completed": Game.words_completed, "words_lost": Game.words_in_fire, "typos_made": Game.typos_made, "typo_modes_triggered": Game.typo_modes_triggered})
	game_ended.emit()

func increase_score(amount: int) -> void:
	current_score += amount
	score_changed.emit(current_score)

func start_typo_mode() -> void:
	typo_mode = true
	typo_mode_started.emit()

func end_typo_mode() -> void:
	typo_mode = false
	typo_mode_ended.emit()

func add_word_to_active(word: String) -> void:
	if not word in active_words:
		active_words.append(word)
		print("Added word to active: ", word)

func remove_word_from_active(word: String) -> void:
	var index = active_words.find(word)
	if index != -1:
		active_words.remove_at(index)
		print("Removed word from active: ", word)

func _unhandled_input(event):
	# using unhandled input so that things like the typo smash mode
	# can mark the input as handled and not propagate to the game.
	# Same for menus
	if typo_mode or not game_active:
		return

	if event is InputEventKey and event.pressed and !event.echo:
		# Convert the keycode to a character
		var character = OS.get_keycode_string(event.keycode).to_upper()

		if not character in alphabet:
			return
		
		input_buffer += character
		letter_typed.emit(character, true)
		print("Current input buffer: ", input_buffer)

		if _is_word_matched(input_buffer):
			get_tree().call_group("words", "complete", input_buffer)
			remove_word_from_active(input_buffer)
			input_buffer = ""
			return
		
		if _has_partial_match(input_buffer):
			partical_match_found.emit(input_buffer)
			return

		# Typo was made.
		_typo_made()

# Private methods

func _reset_game_state() -> void:
	active_words.clear()
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
	current_streak = 0
	max_streak = 0
	difficulty_streak = 0
	score_changed.emit(current_score)

func _is_word_matched(word_to_validate: String) -> bool:
	for word in active_words:
		print("Comparing input_buffer: '", input_buffer, "' with word: '", word, "'")
		print("Word to validate length: ", word_to_validate.length(), " Word length: ", word.length())
		if input_buffer.to_upper() == word.to_upper():
			return true
	return false

func _has_partial_match(word_to_validate: String) -> bool:
	for word in active_words:
		if word.to_lower().begins_with(word_to_validate):
			return true
	return false

func _typo_made() -> void:
	difficulty_streak = 0
	typos_made += 1
	typo.emit(typos_made)
	print("No partial matches found")
	input_buffer = ""

# Signal handlers
func _on_typo_mode_started() -> void:
	typo_modes_triggered += 1

func _on_letter_typed(_letter: String, _is_valid: bool) -> void:
	letters_typed += 1

func _on_word_completed(_word: String) -> void:
	words_completed += 1
	current_streak += 1
	difficulty_streak += 1
	if difficulty_streak > diff_formula(difficulty):
		difficulty += 1
		difficulty_streak = 0
		difficulty_increased.emit()
	if current_streak > max_streak:
		max_streak = current_streak

func _on_word_fell_in_fire(_word: String) -> void:
	words_in_fire += 1
	difficulty_streak = 0