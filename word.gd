extends RigidBody2D
class_name Word

# TODO: update when we expand word list
var max_word_length: int = 10
var max_word_speed: int = -300

var word_length: int = 3
var word_text: String = ""

@onready var highlight_label: Label = $HighlightLabel
@onready var label: Label = $WordLabel
var collision_shape: CollisionShape2D

const SPEED = 150.0

var is_on_floor: bool = false

func _ready() -> void:
	add_to_group("words")
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = randi()
	var lower_bound: int = min(Game.state.difficulty + 2, max_word_length)
	var upper_bound: int = min(Game.state.difficulty + 4, max_word_length)
	print("Lower bound: ", lower_bound, " | Upper bound: ", upper_bound)
	word_length = rng.randi_range(lower_bound, upper_bound)
	var word_length = 8
	word_text = WordsManager.get_random_word(word_length).to_upper()
	Game.add_word_to_active(word_text)
	Game.letter_typed.connect(_on_letter_typed)
	label.text = word_text
	highlight_label.text = ""
	
	# Create a new unique collision shape
	collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size.x = word_length * 18
	shape.size.y = 10  # You can adjust this height as needed
	collision_shape.global_position.y = collision_shape.global_position.y - 10
	collision_shape.shape = shape
	# collision_shape.debug_color = Color.RED
	add_child(collision_shape)
	
	body_entered.connect(_on_body_entered)
	Game.game_ended.connect(_on_game_ended)


func _on_letter_typed(_letter: String, _is_valid: bool) -> void:
	var buffer = Game.state.input_buffer
	if word_text.to_upper().begins_with(buffer):
		var spaces = " ".repeat(word_text.length() - buffer.length())
		highlight_label.text = buffer + spaces
	else:
		highlight_label.text = ""

func _on_body_entered(_body: Node2D) -> void:
	is_on_floor = true


func _physics_process(_delta: float) -> void:
	if not is_on_floor:
		return
	
	linear_velocity.x = -1 * SPEED - (Game.state.difficulty * 20)
	linear_velocity.x = clamp(linear_velocity.x, max_word_speed, 0)

func do_damage() -> void:
	print("do damage")
	Game.remove_word_from_active(word_text)
	Game.word_fell_in_fire.emit(word_text)
	References.health.take_damage(word_text.length() * 3)
	queue_free()

func complete(word_to_complete: String) -> void:
	if not word_to_complete == word_text:
		return
	print("Word completed: ", word_text)
	Game.word_completed.emit(word_text)
	queue_free()

func _on_game_ended() -> void:
	print("Game ended, destorying word: ", word_text)
	queue_free()
