extends Sprite2D

@export var curr_letter: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not curr_letter:
		return
	texture = load("res://assets/Keyboard/%s.png" % curr_letter.to_upper())
	visible = false
	
	Game.letter_typed.connect(_on_letter_typed)

func _on_letter_typed(letter: String, is_valid: bool) -> void:
	print(is_valid)
	if is_valid:
		self_modulate = Color(0, 1, 0, 1)
		var rng: RandomNumberGenerator = RandomNumberGenerator.new()
		if rng.randf() < 0.5:
			SFXPool.stab_random_pitch("key_1", 0.50, 0.75, 1.25)
		else:
			SFXPool.stab_random_pitch("key_2", 0.50, 0.75, 1.25)
	else:
		self_modulate = Color(1, 0, 0, 1)

	if curr_letter == letter.to_lower():
		visible = true
		await get_tree().create_timer(0.4).timeout
		visible = false
