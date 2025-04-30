extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "0"
	Game.score_changed.connect(_update_score)
	

func _update_score(new_score: int) -> void:
	text = str(new_score)
