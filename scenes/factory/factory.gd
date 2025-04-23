extends Node2D

@onready var word_scene: PackedScene = preload("res://word.tscn")
@onready var word_spawn_point: Node2D = $WordSpawnPoint
@onready var timer: Timer = $Timer


@onready var failure_particles: CPUParticles2D = $UI/CurrentTyping/FailureParticles
@onready var success_particles: CPUParticles2D = $UI/CurrentTyping/SuccessParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

	Game.word_completed.connect(_on_word_completed)
	Game.typo.connect(_on_typo)
	Game.word_fell_in_fire.connect(_on_word_fell_in_fire)

func _on_typo(typos_made: int) -> void:
	SoundManager.play_typo()
	Game.decrease_score(1)
	var new_failure_particles = failure_particles.duplicate()
	new_failure_particles.emitting = true
	add_child(new_failure_particles)
	await get_tree().create_timer(0.5).timeout
	new_failure_particles.queue_free()

func _on_word_fell_in_fire(word: String) -> void:
	Game.decrease_score(word.length() * 3)
	SoundManager.play_failed_word()

func _on_word_completed(word: String) -> void:
	Game.increase_score(word.length() * 3)
	SoundManager.play_completed()
	var new_success_particles = success_particles.duplicate()
	new_success_particles.emitting = true
	add_child(new_success_particles)
	await get_tree().create_timer(0.5).timeout
	new_success_particles.queue_free()

func _on_timer_timeout() -> void:
	if not Game.game_active:
		return
	var word = word_scene.instantiate()
	word.position = word_spawn_point.position
	add_child(word)
