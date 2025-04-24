extends Node
var alphabet: Array[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

signal word_completed(word: String)
signal partical_match_found(word: String)
signal typo(typos_made: int)
signal typo_grace(typos_made: int)
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

var default_state: Dictionary = {
	"invulnerable": false,
	"typo_mode": false,
	"typos_made": 0,
	"typo_modes_triggered": 0,
	"words_completed": 0,
	"words_in_fire": 0,
	"letters_typed": 0,
	"difficulty": 1,
	"current_streak": 0,
	"difficulty_streak": 0,
	"current_score": 0,
	"game_active": false,
	"current_typing": "",
	"input_buffer": "",
	"active_words": [],
}

var state: Dictionary = default_state.duplicate()

var invulnerable_time: float = 1.0
var player_emojis: String = ""
var max_streak: int = 0

func _ready():
	connect_signals()

func connect_signals() -> void:
	letter_typed.connect(_on_letter_typed)
	word_completed.connect(_on_word_completed)
	word_fell_in_fire.connect(_on_word_fell_in_fire)
	typo_mode_started.connect(_on_typo_mode_started)

func get_streak_to_next_difficulty() -> int:
	return diff_formula(state.difficulty) - state.difficulty_streak + 1

func diff_formula(curr_difficulty: int) -> int:
	return curr_difficulty * 2 + curr_difficulty

func start_game() -> void:
	reset_game_state()
	state.game_active = true
	game_started.emit()

func end_game() -> void:
	state.game_active = false
	References.game_controller.load_leaderboard()
	await Leaderboards.post_guest_score(References.quiver_leaderboard_id, state.current_score, player_emojis, {"difficulty": state.difficulty, "words_completed": state.words_completed, "words_lost": state.words_in_fire, "typos_made": state.typos_made, "typo_modes_triggered": state.typo_modes_triggered})
	game_ended.emit()

func increase_score(amount: int) -> void:
	state.current_score += amount
	score_changed.emit(state.current_score)

func decrease_score(amount: int) -> void:
	state.current_score -= amount
	score_changed.emit(state.current_score)

func start_typo_mode() -> void:
	state.typo_mode = true
	typo_mode_started.emit()

func end_typo_mode() -> void:
	state.typo_mode = false
	typo_mode_ended.emit()

func add_word_to_active(word: String) -> void:
	if not word in state.active_words:
		state.active_words.append(word)
		print("Added word to active: ", word)

func remove_word_from_active(word: String) -> void:
	var index = state.active_words.find(word)
	if index != -1:
		state.active_words.remove_at(index)
		print("Removed word from active: ", word)

func _unhandled_input(event):
	# using unhandled input so that things like the typo smash mode
	# can mark the input as handled and not propagate to the game.
	# Same for menus
	if state.typo_mode or not state.game_active:
		return

	if event is InputEventKey and event.pressed and !event.echo:
		# Convert the keycode to a character
		var character = OS.get_keycode_string(event.keycode).to_upper()

		if not character in alphabet:
			return
		
		state.input_buffer += character
		letter_typed.emit(character, true)
		print("Current input buffer: ", state.input_buffer)

		if _is_word_matched(state.input_buffer):
			print("Word matched: ", state.input_buffer)
			get_tree().call_group("words", "complete", state.input_buffer)
			remove_word_from_active(state.input_buffer)
			state.input_buffer = ""
			return
		
		if _has_partial_match(state.input_buffer):
			partical_match_found.emit(state.input_buffer)
			return

		# Typo was made.
		_typo_made()

# Private methods

func reset_game_state() -> void:
	state = default_state.duplicate()

func _is_word_matched(word_to_validate: String) -> bool:
	for word in state.active_words:
		print("Comparing input_buffer: '", state.input_buffer.to_lower(), "' with word: '", word.to_lower(), "'")
		print("Word to validate length: ", word_to_validate.length(), " Word length: ", word.length())

		if state.input_buffer.to_lower() == word.to_lower():
			return true
	return false

func _has_partial_match(word_to_validate: String) -> bool:
	for word in state.active_words:
		if word.to_lower().begins_with(word_to_validate.to_lower()):
			return true
	return false

func _typo_made() -> void:
	state.typos_made += 1
	state.input_buffer = ""
	if state.invulnerable:
		typo_grace.emit(state.typos_made)
		return
	state.difficulty_streak = 0
	typo.emit(state.typos_made)
	print("No partial matches found")

# Signal handlers
func _on_typo_mode_started() -> void:
	state.typo_modes_triggered += 1

func _on_letter_typed(_letter: String, _is_valid: bool) -> void:
	state.letters_typed += 1

func _on_word_completed(_word: String) -> void:
	state.words_completed += 1
	state.current_streak += 1
	state.difficulty_streak += 1
	if state.difficulty_streak > diff_formula(state.difficulty):
		state.difficulty += 1
		state.difficulty_streak = 0
		difficulty_increased.emit()
	if state.current_streak > max_streak:
		max_streak = state.current_streak

func _on_word_fell_in_fire(_word: String) -> void:
	state.words_in_fire += 1
	state.difficulty_streak = 0
