extends Control

@onready var typo_value: Label = %TypoValue
@onready var score_value: Label = %ScoreValue
@onready var complete_value: Label = %CompleteValue
@onready var fire_value: Label = %FireValue

@onready var retry_button: Button = %Retry
@onready var main_menu_button: Button = %MainMenu

var score_color: Color = Color(0.188, 0.094, 0.035, 1)
var negative_color: Color = Color.RED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	retry_button.pressed.connect(_on_retry_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	typo_value.text = str(Game.typos_made)
	complete_value.text = str(Game.words_completed)
	fire_value.text = str(Game.words_in_fire)
	set_score(Game.current_score)

func _on_retry_pressed() -> void:
	References.game_controller.load_factory()

func _on_main_menu_pressed() -> void:
	References.game_controller.load_main_menu()
	
func set_score(score: int) -> void:
	if score < 0:
		print("score is negative")
		score = score * -1
		score_value.label_settings.font_color = Color.RED
		score_value.label_settings.outline_size = 5
	else:
		score_value.label_settings.font_color = score_color
		score_value.label_settings.outline_size = 0
	score_value.text = str(score)
