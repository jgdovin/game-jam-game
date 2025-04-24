extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = ""
	Game.letter_typed.connect(_on_letter_typed)
	Game.typo.connect(_on_typo)
	Game.word_fell_in_fire.connect(_on_word_fell_in_fire)
	Game.word_completed.connect(_on_word_completed)

func _on_letter_typed(_letter: String, _is_valid: bool) -> void:
	text = Game.state.input_buffer

func _on_typo(_typos_made: int) -> void:
	text = ""

func _on_word_fell_in_fire(_word: String) -> void:
	pass

func _on_word_completed(_word: String) -> void:
	text = ""
