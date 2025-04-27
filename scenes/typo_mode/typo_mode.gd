extends Node2D
var alphabet: Array[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
@onready var sprite: Sprite2D = $Sprite2D
@onready var progress_bar: ProgressBar = $ProgressBar

var current_letter: String = ""
var current_progress: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Game.typo_mode_started.connect(_on_typo_mode_started)
	Game.typo_mode_ended.connect(_on_typo_mode_ended)

func _on_typo_mode_started() -> void:
	visible = true
	current_progress = 0.0
	current_letter = alphabet[randi() % alphabet.size()]
	sprite.texture = load("res://assets/Keyboard/%s.png" % current_letter)
	SoundManager.play_typo_music()

func _on_typo_mode_ended() -> void:
	visible = false
	SoundManager.play_game_music()

func _process(delta: float) -> void:
	if current_progress < 0.0:
		return
	current_progress -= 20 * delta
	progress_bar.value = current_progress

func _input(event: InputEvent):
	if not Game.state.typo_mode or Game.state.game_over:
		return
	if event is InputEventKey and event.pressed and !event.echo:
		print("event.keycode: ", event.keycode)
		if OS.get_keycode_string(event.keycode) == current_letter:
			current_progress += 10.0
			progress_bar.value = current_progress
	if current_progress >= 100.0:
		Game.end_typo_mode()
	get_viewport().set_input_as_handled()
