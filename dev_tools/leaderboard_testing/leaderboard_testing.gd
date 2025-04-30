extends Node2D

var base_url = "https://quiver.dev"
var register_guest_path = "/player-accounts/register/"
var leaderboard_id = "typo-factory-dev_testing_onl-o7bQ"
var post_score_path = "/leaderboards/%s/scores/post/" % leaderboard_id
var auth_token = "rIbSdPTRfFgLihJGMdRgpKzyqi4jPrhnbwJv0KDS"

@onready var submit_button: Button = %Submit
@onready var get_button: Button = %Get
@onready var get_nearby_button: Button = %GetNearby
@onready var player_score: TextEdit = %PlayerScore
@onready var player_name: TextEdit = %PlayerName
@onready var player_rank: TextEdit = %PlayerRank

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	submit_button.pressed.connect(submit_score)
	get_button.pressed.connect(get_scores)
	get_nearby_button.pressed.connect(get_nearby_scores)

func submit_score() -> void:
	var score = int(player_score.text)
	var success = await Leaderboards.post_guest_score(leaderboard_id, score, player_name.text)
	print(success)
	
func get_scores() -> void:
	var scores = await Leaderboards.get_scores(leaderboard_id, 0, 10)
	print(scores)

func get_nearby_scores() -> void:
	print(await Leaderboards.get_player_latest_rank(leaderboard_id))
