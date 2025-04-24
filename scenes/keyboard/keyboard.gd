extends Sprite2D

@onready var key_scene: PackedScene = preload("res://scenes/keyboard/key.tscn")
@onready var keyboard_start_point: Node2D = $KeyboardStartPoint

var row_1: Array[String] = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
var row_2: Array[String] = ["a", "s", "d", "f", "g", "h", "j", "k", "l"]
var row_3: Array[String] = ["z", "x", "c", "v", "b", "n", "m"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(row_1.size()):
		var key_instance = key_scene.instantiate()
		key_instance.curr_letter = row_1[i]
		key_instance.position = keyboard_start_point.position + Vector2(i * 30, -1)
		add_child(key_instance)
	
	for i in range(row_2.size()):
		var key_instance = key_scene.instantiate()
		key_instance.curr_letter = row_2[i]
		key_instance.position = keyboard_start_point.position + Vector2(i * 30 + 15, 32)
		add_child(key_instance)

	for i in range(row_3.size()):
		var key_instance = key_scene.instantiate()
		key_instance.curr_letter = row_3[i]
		key_instance.position = keyboard_start_point.position + Vector2(i * 30 + 30, 66)
		add_child(key_instance)
