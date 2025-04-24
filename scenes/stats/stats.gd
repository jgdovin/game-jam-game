extends Control

@onready var next_difficulty_level_label: Label = %NextDifficultyValue
@onready var curr_difficulty_level_label: Label = %CurrDifficultyValue
@onready var typos_label: Label = %TyposValue
@onready var completed_value: Label = %CompletedValue
@onready var lost_value: Label = %LostValue
@onready var curr_streak_value: Label = %CurrStreakValue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.difficulty_increased.connect(_on_difficulty_increased)
	Game.word_completed.connect(_on_word_completed)
	Game.word_fell_in_fire.connect(_on_word_fell_in_fire)
	Game.typo.connect(_on_typo)

	curr_difficulty_level_label.text = str(Game.state.difficulty)
	next_difficulty_level_label.text = str(Game.get_streak_to_next_difficulty())

func _on_difficulty_increased() -> void:
	curr_difficulty_level_label.text = str(Game.state.difficulty)
	next_difficulty_level_label.text = str(Game.get_streak_to_next_difficulty())

func _on_word_completed(_word: String) -> void:
	completed_value.text = str(Game.state.words_completed)
	next_difficulty_level_label.text = str(Game.get_streak_to_next_difficulty())
	curr_streak_value.text = str(Game.state.current_streak)

func _on_word_fell_in_fire(_word: String) -> void:
	lost_value.text = str(Game.state.words_in_fire)
	next_difficulty_level_label.text = str(Game.get_streak_to_next_difficulty())

func _on_typo(typos_made: int) -> void:
	typos_label.text = str(typos_made)
	curr_streak_value.text = str(Game.state.current_streak)
	next_difficulty_level_label.text = str(Game.get_streak_to_next_difficulty())
