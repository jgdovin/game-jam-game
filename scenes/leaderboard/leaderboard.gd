extends Control

@onready var score_line: PackedScene = preload("res://scenes/leaderboard/score_line.tscn")

@export var curve: Curve

@onready var home_button: Button = %Home
@onready var new_run_button: Button = %NewRun
@onready var loading_label: Label = %Loading
@onready var score_holder: Node = %ScoreHolder
@onready var player_score: Node = %PlayerScore
@onready var player_score_container: PanelContainer = %PlayerScoreContainer
@onready var tooltip_container: Control = %Tooltips
@onready var scroll_container: ScrollContainer = %ScrollContainer

@onready var game_over_label: Label = %GameOver

var center_position = 4
var score_line_height: int = 30

var player_rank: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loading_label.visible = true
	_setup_signals()
	player_rank = await Leaderboards.get_player_latest_rank(References.quiver_leaderboard_id)
	print("PLAYER RANK ", player_rank)
	Game.end_typo_mode()
	if Game.state.game_over:
		# _show_player_score()
		game_over_label.visible = true
		new_run_button.text = "Retry"
		Game.state.game_over = false
	else:
		player_score_container.visible = false
	
	# scores = await Leaderboards.get_scores(References.quiver_leaderboard_id, 0, 50)
	if player_rank > 25:
		var top_five_scores = await Leaderboards.get_scores(References.quiver_leaderboard_id, 0, 5)
		print("TOP FIVE SCORES ", top_five_scores)
		add_scores_to_ui(top_five_scores.scores)
		
		var nearby_scores = await Leaderboards.get_nearby_scores(References.quiver_leaderboard_id, 25, Leaderboards.NearbyAnchor.LATEST)
		# handle 3 scenarios
		if nearby_scores.scores.is_empty():
			printerr("SCORES IS EMPTY")
			return

		add_scores_to_ui(nearby_scores.scores)
	else:
		var scores = await Leaderboards.get_scores(References.quiver_leaderboard_id, 0, 50)
		add_scores_to_ui(scores.scores)

	if not player_rank:
		var scores = await Leaderboards.get_scores(References.quiver_leaderboard_id, 0, 50)
		add_scores_to_ui(scores.scores)
		loading_label.visible = false
		return
	
	loading_label.visible = false
	await get_tree().create_timer(0.1).timeout

	# TODO: Tween this bitch with a rubber band
	var tween = create_tween()
	var scroll_to: int
	if player_rank > 50:
		scroll_to = 31 - center_position
	else:
		scroll_to = player_rank - center_position
	tween.tween_property(scroll_container, "scroll_vertical", max(scroll_to, 0) * score_line_height, 1.5).as_relative().set_custom_interpolator(tween_curve)
	# var scroll_height = max(curr_position - center_position, 0) * score_line_height
	# scroll_container.set_deferred("scroll_vertical", scroll_height)

func add_scores_to_ui(scores: Array) -> void:
	for i in scores.size():
		var score = scores[i]
		var score_instance = score_line.instantiate()
		if score.rank == player_rank:
			score_instance.is_current_player = true
		score_instance.data = score
		score_holder.add_child(score_instance)

func tween_curve(v):
	return curve.sample_baked(v)

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
