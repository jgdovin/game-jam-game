extends ProgressBar
class_name Health

@export var base_health: int = 100
var current_health: int = base_health

signal health_changed(new_health: int)
signal health_depleted()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	References.health = self
	current_health = base_health
	value = current_health

func take_damage(amount: int) -> void:
	current_health -= amount
	value = current_health
	health_changed.emit(current_health)
	if current_health <= 0:
		health_depleted.emit()
		Game.end_game()
