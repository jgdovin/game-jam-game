extends CanvasLayer

@onready var typo_value: Label = %TypoValue
@onready var score_value: Label = %ScoreValue
var score_color: Color = Color(0.651, 0.561, 0.506, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Game.typo.connect(_on_typo)
	References.health.health_depleted.connect(_on_health_depleted)
	Game.score_changed.connect(_on_score_changed)

func _on_typo(typos_made: int) -> void:
	typo_value.text = str(typos_made)

func _on_health_depleted() -> void:
	visible = true

func _on_score_changed(score: int) -> void:
	if score < 0:
		print("score is negative")
		score = score * -1
		score_value.label_settings.font_color = Color.RED
	else:
		score_value.label_settings.font_color = score_color
	score_value.text = str(score)
