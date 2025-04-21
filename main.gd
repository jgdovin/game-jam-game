extends Node2D

@onready var word_scene: PackedScene = preload("res://word.tscn")
@onready var word_spawn_point: Node2D = $WordSpawnPoint
@onready var despawn_area: Area2D = $FirePitBase/DespawnArea
@onready var particles: CPUParticles2D = $FirePitBase/Particles
@onready var score: Label = $GameUI/Score
@onready var timer: Timer = $Timer
@onready var failed_sound: AudioStreamPlayer = $Failed
@onready var completed_sound: AudioStreamPlayer = $Completed
@onready var current_typing: Label = $CurrentTyping

@onready var failure_particles: CPUParticles2D = $CurrentTyping/FailureParticles
@onready var success_particles: CPUParticles2D = $CurrentTyping/SuccessParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	despawn_area.body_entered.connect(_on_despawn_area_body_entered)
	score.text = "0"
	current_typing.text = ""

	Game.word_completed.connect(_on_word_completed)
	Game.word_failed.connect(_on_word_failed)
	Game.letter_typed.connect(_on_letter_typed)
	Game.word_fell_in_fire.connect(_on_word_fell_in_fire)


func _on_letter_typed(_letter: String, _is_valid: bool) -> void:
	current_typing.text = Game.input_buffer

func _on_word_failed() -> void:
	current_typing.text = ""
	score.text = str(int(score.text) - 1)
	failed_sound.play()
	var new_failure_particles = failure_particles.duplicate()
	new_failure_particles.emitting = true
	add_child(new_failure_particles)
	await get_tree().create_timer(0.5).timeout
	new_failure_particles.queue_free()

func _on_word_fell_in_fire(_word: String) -> void:
	score.text = str(int(score.text) - 10)
	failed_sound.play()
	current_typing.text = ""

func _on_word_completed(word: String) -> void:
	current_typing.text = ""
	score.text = str(int(score.text) + word.length() * 3)
	completed_sound.play()
	var new_success_particles = success_particles.duplicate()
	new_success_particles.emitting = true
	add_child(new_success_particles)
	await get_tree().create_timer(0.5).timeout
	new_success_particles.queue_free()

func _on_despawn_area_body_entered(body: Node2D) -> void:
	if body is Word:
		body.do_damage()
		particles.emitting = true

func _on_timer_timeout() -> void:
	var word = word_scene.instantiate()
	word.position = word_spawn_point.position
	add_child(word)
