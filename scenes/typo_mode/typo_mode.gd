extends Node2D
var alphabet: Array[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label: Label = %Label
@onready var rotator: Node2D = $Rotator

var current_letter: String = ""
var current_progress: float = 0.0
var steps_increase: float = 1.0
var steps_decrease: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Game.typo_mode_started.connect(_on_typo_mode_started)
	Game.typo_mode_ended.connect(_on_typo_mode_ended)
	Game.difficulty_increased.connect(_on_difficulty_increased)
	progress_bar.max_value = get_progress_bar_based_on_difficulty()
	print("progress_bar.max_value: ", progress_bar.max_value)

func _on_typo_mode_started() -> void:
	visible = true
	current_progress = 0.0
	current_letter = alphabet[randi() % alphabet.size()]
	label.text = current_letter
	SoundManager.play_typo_music()
	progress_bar.max_value = get_progress_bar_based_on_difficulty()


func _on_difficulty_increased() -> void:
	progress_bar.max_value = get_progress_bar_based_on_difficulty()

func get_progress_bar_based_on_difficulty() -> float:
	return Game.state.difficulty * 2

func _on_typo_mode_ended() -> void:
	visible = false
	SoundManager.play_game_music()

func _process(delta: float) -> void:
	rotator.rotation += 0.1
	if current_progress < 0.0:
		return
	current_progress -= steps_decrease * delta
	progress_bar.value = current_progress

func _input(event: InputEvent):
	if not Game.state.typo_mode or Game.state.game_over:
		return
	if event is InputEventKey and event.pressed and !event.echo:
		if OS.get_keycode_string(event.keycode) == current_letter:
			current_progress += steps_increase
			progress_bar.value = current_progress
	if current_progress >= get_progress_bar_based_on_difficulty():
		Game.end_typo_mode()
	get_viewport().set_input_as_handled()
