extends Control

@onready var end_game_button: Button = %EndGame
@onready var typo_mode_button: Button = %TypoMode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	end_game_button.pressed.connect(_on_end_game_button_pressed)
	typo_mode_button.pressed.connect(_on_typo_mode_button_pressed)

func _on_end_game_button_pressed() -> void:
	Game.end_game()

func _on_typo_mode_button_pressed() -> void:
	Game.start_typo_mode()
