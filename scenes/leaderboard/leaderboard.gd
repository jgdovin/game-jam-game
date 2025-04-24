extends Control

@onready var score_line: PackedScene = preload("res://scenes/leaderboard/score_line.tscn")

@onready var home_button: Button = %Home
@onready var new_run_button: Button = %NewRun
@onready var loading_label: Label = %Loading
@onready var score_holder: Node = %ScoreHolder
@onready var player_score: Node = %PlayerScore
@onready var player_score_container: PanelContainer = %PlayerScoreContainer
@onready var tooltip_container: Control = %Tooltips

@onready var game_over_label: Label = %GameOver

@onready var difficulty_tooltip: Control = %DifficultyTooltip
@onready var words_completed_tooltip: Control = %WordsCompletedTooltip
@onready var words_lost_tooltip: Control = %WordsLostTooltip

var scores: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_signals()

	if Game.current_score:
		_show_player_score()
		game_over_label.visible = true
		new_run_button.text = "Retry"
	else:
		player_score_container.visible = false

	scores = await Leaderboards.get_player_scores(References.quiver_leaderboard_id)
	print("SCORES ", scores)
	for score in scores.scores:
		var score_instance = score_line.instantiate()
		score_instance.data = score
		score_holder.add_child(score_instance)
	loading_label.visible = false


func _show_player_score() -> void:
	var score_instance = score_line.instantiate()
	score_instance.data = {"name": Game.player_emojis, "score": Game.current_score, "timestamp": Time.get_datetime_string_from_system(false, true), "metadata": {"difficulty": Game.difficulty, "words_completed": Game.words_completed, "words_lost": Game.words_in_fire, "typos_made": Game.typos_made, "typo_modes_triggered": Game.typo_modes_triggered}, "is_current_player": true}
	player_score.add_child(score_instance)

func _on_home_pressed() -> void:
	References.game_controller.load_main_menu()
	Game.reset_game_state()

func _on_new_run_pressed() -> void:
	References.game_controller.load_factory()

func _setup_signals() -> void:
	home_button.pressed.connect(_on_home_pressed)
	new_run_button.pressed.connect(_on_new_run_pressed)


func _on_difficulty_label_mouse_entered() -> void:
	difficulty_tooltip.visible = true

func _on_words_completed_label_mouse_entered() -> void:
	words_completed_tooltip.visible = true

func _on_words_lost_label_mouse_entered() -> void:
	words_lost_tooltip.visible = true

func _on_difficulty_label_mouse_exited() -> void:
	difficulty_tooltip.visible = false

func _on_words_completed_label_mouse_exited() -> void:
	words_completed_tooltip.visible = false

func _on_words_lost_label_mouse_exited() -> void:
	words_lost_tooltip.visible = false
