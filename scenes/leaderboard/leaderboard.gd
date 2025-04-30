extends Control

@onready var score_line: PackedScene = preload("res://scenes/leaderboard/score_line.tscn")

@onready var home_button: Button = %Home
@onready var new_run_button: Button = %NewRun
@onready var loading_label: Label = %Loading
@onready var score_holder: Node = %ScoreHolder
@onready var player_score: Node = %PlayerScore
@onready var player_score_container: PanelContainer = %PlayerScoreContainer
@onready var tooltip_container: Control = %Tooltips
@onready var scroll_container: ScrollContainer = %ScrollContainer

@onready var game_over_label: Label = %GameOver

var scores: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_signals()
	Game.end_typo_mode()
	if Game.state.game_over:
		_show_player_score()
		game_over_label.visible = true
		new_run_button.text = "Retry"
		Game.state.game_over = false
	else:
		player_score_container.visible = false

	scores = await Leaderboards.get_scores(References.quiver_leaderboard_id, 0, 50)
	print("SCORES ", scores)
	for score in scores.scores:
		var score_instance = score_line.instantiate()
		score_instance.data = score
		score_holder.add_child(score_instance)
	loading_label.visible = false


func _show_player_score() -> void:
	var score_instance = score_line.instantiate()
	score_instance.data = {"name": Game.player_emojis, "score": Game.state.current_score, "timestamp": Time.get_datetime_string_from_system(false, true), "metadata": {"difficulty": Game.state.difficulty, "words_completed": Game.state.words_completed, "words_lost": Game.state.words_in_fire, "typos_made": Game.state.typos_made, "typo_modes_triggered": Game.state.typo_modes_triggered}, "is_current_player": true}
	player_score.add_child(score_instance)

func _on_home_pressed() -> void:
	References.game_controller.load_main_menu()
	Game.reset_game_state()

func _on_new_run_pressed() -> void:
	References.game_controller.load_factory()

func _setup_signals() -> void:
	home_button.pressed.connect(_on_home_pressed)
	new_run_button.pressed.connect(_on_new_run_pressed)
