extends Sprite2D

var random_times: Vector2 = Vector2(10.0, 20.0)
var time: float = 0.0
var time_to_change: float = 0.0

@onready var cpu_particles: CPUParticles2D = $CPUParticles2D

func pick_random_time() -> float:
	return randf_range(random_times.x, random_times.y)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_to_change = pick_random_time()
	time = 0.0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time >= time_to_change:
		time = 0.0
		time_to_change = pick_random_time()
		frame = 0
		cpu_particles.emitting = true
