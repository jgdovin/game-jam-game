extends Label

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Game.difficulty_increased.connect(_on_difficulty_increased)

func _on_difficulty_increased() -> void:
	visible = true
	animation_player.play("disappear")

func _hide() -> void:
	visible = false
