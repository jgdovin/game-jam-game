extends HBoxContainer

var data: Dictionary

@onready var emoji_holder: HBoxContainer = %EmojiHolder

@onready var rank_label: Label = $Rank
@onready var score_label: Label = $Score
@onready var difficulty_label: Label = $Difficulty
@onready var completed_label: Label = $Completed
@onready var lost_label: Label = $Lost
@onready var typos_label: Label = $Typo
@onready var smash_label: Label = $Smash

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not data:
		printerr("No data for score line")
		return
	emoji_holder.set_emoji_display_override(data.get("name", ""))
	rank_label.text = str(int(data.get("rank", "")))
	score_label.text = str(int(data.get("score", "")))
	difficulty_label.text = str(int(data.get("metadata", {}).get("difficulty", "")))
	completed_label.text = str(int(data.get("metadata", {}).get("words_completed", "")))
	lost_label.text = str(int(data.get("metadata", {}).get("words_lost", "")))
	typos_label.text = str(int(data.get("metadata", {}).get("typos_made", "")))
	smash_label.text = str(int(data.get("metadata", {}).get("typo_modes_triggered", "")))
	# SCORES { "scores": [{ "name": "Test Player", "score": 716.0, "rank": 1.0, "timestamp": 1745441425.34, "metadata": { "typos_made": 7.0, "words_in_fire": 4.0, "words_completed": 47.0 }, "is_current_player": true }], "has_more_scores": false, "error": "" }
