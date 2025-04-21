extends Sprite2D
@onready var despawn_area: Area2D = $DespawnArea
@onready var particles: CPUParticles2D = $Particles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	despawn_area.body_entered.connect(_on_despawn_area_body_entered)

func _on_despawn_area_body_entered(body: Node2D) -> void:
	if body is Word:
		body.do_damage()
		particles.emitting = true