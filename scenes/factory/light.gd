extends AnimatedSprite2D
var random_time: float = 0.0
var time: float = 0.0
var random_time_min: float = 1.5
var random_time_max: float = 5.0

func pick_random_time() -> float:
	return randf_range(random_time_min, random_time_max)

func _ready() -> void:
	random_time = pick_random_time()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time >= random_time:
		time = 0.0
		random_time = pick_random_time()
		frame = 0
		play('default')
