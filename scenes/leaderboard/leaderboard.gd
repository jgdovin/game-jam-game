extends Control

@onready var score_line: PackedScene = preload("res://scenes/leaderboard/score_line.tscn")

@onready var loading_label: Label = %Loading
@onready var score_holder: Node = %ScoreHolder
var scores: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scores = await Leaderboards.get_player_scores(References.quiver_leaderboard_id)
	print("SCORES ", scores)
	for score in scores.scores:
		var score_instance = score_line.instantiate()
		score_instance.data = score
		score_holder.add_child(score_instance)
	loading_label.visible = false
