extends Node2D

@onready var score: Label = $GameUI/Score
@onready var toggle_typo_button: Button = $GameUI/ToggleTypo
@onready var word_scene: PackedScene = preload("res://word.tscn")
@onready var word_spawn_point: Node2D = $WordSpawnPoint
@onready var timer: Timer = $Timer


@onready var failure_particles: CPUParticles2D = $CurrentTyping/FailureParticles
@onready var success_particles: CPUParticles2D = $CurrentTyping/SuccessParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	score.text = "0"

	Game.word_completed.connect(_on_word_completed)
	Game.typo.connect(_on_typo)
	Game.word_fell_in_fire.connect(_on_word_fell_in_fire)
	toggle_typo_button.pressed.connect(_on_toggle_typo_button_pressed)

func _on_toggle_typo_button_pressed() -> void:
	if Game.typo_mode:
		Game.end_typo_mode()
	else:
		Game.start_typo_mode()

func _on_typo() -> void:
	SoundManager.play_typo()
	Game.current_score -= 1
	_set_score_color()
	var new_failure_particles = failure_particles.duplicate()
	new_failure_particles.emitting = true
	add_child(new_failure_particles)
	await get_tree().create_timer(0.5).timeout
	new_failure_particles.queue_free()

func _on_word_fell_in_fire(word: String) -> void:
	Game.current_score -= word.length() * 3
	_set_score_color()
	SoundManager.play_failed_word()

func _on_word_completed(word: String) -> void:
	Game.current_score += word.length() * 3
	_set_score_color()
	SoundManager.play_completed()
	var new_success_particles = success_particles.duplicate()
	new_success_particles.emitting = true
	add_child(new_success_particles)
	await get_tree().create_timer(0.5).timeout
	new_success_particles.queue_free()



func _on_timer_timeout() -> void:
	var word = word_scene.instantiate()
	word.position = word_spawn_point.position
	add_child(word)

func _set_score_color() -> void:
	print(Game.current_score)
	if Game.current_score < 0:
		score.text = str(Game.current_score * -1)
		score.self_modulate = Color(1, 0, 0, 1)
	else:
		score.text = str(Game.current_score)
		score.self_modulate = Color(0, 1, 0, 1)
