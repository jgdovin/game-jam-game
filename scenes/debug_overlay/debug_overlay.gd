extends Control

@onready var end_game_button: Button = %EndGame
@onready var typo_mode_button: Button = %TypoMode
@onready var increase_difficulty_button: Button = %IncreaseDifficulty

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
	end_game_button.pressed.connect(_on_end_game_button_pressed)
	typo_mode_button.pressed.connect(_on_typo_mode_button_pressed)
	increase_difficulty_button.pressed.connect(_on_increase_difficulty_button_pressed)

func _on_end_game_button_pressed() -> void:
	Game.end_game()

func _on_typo_mode_button_pressed() -> void:
	Game.start_typo_mode()

func _on_increase_difficulty_button_pressed() -> void:
	Game.increase_difficulty()
