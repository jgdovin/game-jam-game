extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "0"
	_set_score_color()
	Game.score_changed.connect(_update_score)

func _update_score(new_score) -> void:
	text = str(new_score)
	_set_score_color()

func _set_score_color() -> void:
	print(Game.current_score)
	if Game.current_score < 0:
		text = str(Game.current_score * -1)
		self_modulate = Color(1, 0, 0, 1)
	else:
		text = str(Game.current_score)
		self_modulate = Color(0, 1, 0, 1)