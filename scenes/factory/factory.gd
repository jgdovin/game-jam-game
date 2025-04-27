extends Node2D

@onready var word_scene: PackedScene = preload("res://word.tscn")
@onready var word_spawn_point: Node2D = $WordSpawnPoint
@onready var word_holder_layer: Node2D = %WordHolderLayer
@onready var background_layer: TextureRect = %Background

@onready var failure_particles: CPUParticles2D = $UI/CurrentTyping/FailureParticles
@onready var success_particles: CPUParticles2D = $UI/CurrentTyping/SuccessParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_layer.visible = true
	SoundManager.play_game_music()
	Game.start_game()

	Game.word_completed.connect(_on_word_completed)
	Game.typo.connect(_on_typo)
	Game.word_fell_in_fire.connect(_on_word_fell_in_fire)
	Game.typo_grace.connect(_on_typo_grace)

func _on_typo_grace(_typos_made: int) -> void:
	SFXPool.stab_random_pitch("typo_grace", 1.0, 0.75, 1.25)

func _on_typo(_typos_made: int) -> void:
	SFXPool.stab_random_pitch("typo", 1.0, 0.75, 1.25)
	var new_failure_particles = failure_particles.duplicate()
	new_failure_particles.emitting = true
	add_child(new_failure_particles)
	await get_tree().create_timer(0.5).timeout
	new_failure_particles.queue_free()

func _on_word_fell_in_fire(_word: String) -> void:
	SFXPool.stab_random_pitch("burn", 1.0, 0.5, 1.5)

func _on_word_completed(word: String) -> void:
	Game.increase_score(word.length() * 3)
	SFXPool.stab("completed")
	var new_success_particles = success_particles.duplicate()
	new_success_particles.emitting = true
	add_child(new_success_particles)
	await get_tree().create_timer(0.5).timeout
	new_success_particles.queue_free()

func spawn_word() -> void:
	if not Game.state.game_active:
		return
	var word = word_scene.instantiate()
	word.position = word_spawn_point.position
	word_holder_layer.add_child(word)
