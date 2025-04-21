extends RigidBody2D
class_name Word

var word_length: int = 3
var word_text: String = ""

@onready var label: Label = $Label
var collision_shape: CollisionShape2D

var is_on_floor: bool = false

func _ready() -> void:
	add_to_group("words")
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = randi()
	word_length = rng.randi_range(3, 6)
	word_text = Game.get_random_word(word_length)
	Game.add_word_to_active(word_text)
	label.text = word_text
	
	# Create a new unique collision shape
	collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size.x = word_length * 24
	shape.size.y = 32  # You can adjust this height as needed
	collision_shape.shape = shape
	# collision_shape.debug_color = Color.RED
	add_child(collision_shape)
	
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node2D) -> void:
	is_on_floor = true

const SPEED = 200.0

func _physics_process(_delta: float) -> void:
	if not is_on_floor:
		return
	
	linear_velocity.x = -1 * SPEED

func do_damage() -> void:
	print("do damage")
	Game.word_failed.emit()
	queue_free()

func complete() -> void:
	print("Word completed: ", word_text)
	queue_free()
