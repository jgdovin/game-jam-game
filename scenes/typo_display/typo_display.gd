extends PanelContainer

@onready var x1: Label = %X1
@onready var x2: Label = %X2
@onready var x3: Label = %X3

@onready var labels: Array = [x1, x2, x3]

var typo_count: int = 0
var invulnerable: bool = false
var invulnerable_time: float = 1.0

func _ready() -> void:
	Game.typo.connect(_on_typo)
	Game.typo_mode_ended.connect(_on_typo_mode_ended)
	for label in labels:
		label.self_modulate = Color(.286, .384, .431, 1)

func _on_typo(typos_made: int) -> void:
	if invulnerable:
		return
	typo_count += 1
	_update_typo_display()
	if typo_count >= 3:
		Game.start_typo_mode()
	else:
		invulnerable = true
		await get_tree().create_timer(invulnerable_time).timeout
		invulnerable = false

func _on_typo_mode_ended() -> void:
	typo_count = 0
	_update_typo_display()

func _update_typo_display() -> void:
	for i in range(3):
		labels[i].self_modulate = Color(1, .631, .188, 1) if i < typo_count else Color(.286, .384, .431, 1)
