extends Node2D

@onready var word_scene: PackedScene = preload("res://word.tscn")
@onready var word_spawn_point: Node2D = $WordSpawnPoint
@onready var despawn_area: Area2D = $FirePitBase/DespawnArea
@onready var particles: CPUParticles2D = $FirePitBase/Particles
@onready var score: Label = $GameUI/Score
@onready var timer: Timer = $Timer
@onready var failed_sound: AudioStreamPlayer = $Failed
@onready var completed_sound: AudioStreamPlayer = $Completed
@onready var current_typing: Label = $GameUI/CurrentTyping

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	despawn_area.body_entered.connect(_on_despawn_area_body_entered)
	score.text = "0"
	current_typing.text = ""
	
	Game.word_completed.connect(_on_word_completed)
	Game.word_failed.connect(_on_word_failed)
	Game.letter_typed.connect(_on_letter_typed)

func _on_letter_typed(_letter: String) -> void:
	print(current_typing)
	current_typing.text = Game.input_buffer

func _on_word_failed() -> void:
	score.text = str(int(score.text) - 10)
	failed_sound.play()
func _on_word_completed(word: String) -> void:
	score.text = str(int(score.text) + word.length() * 3)
	completed_sound.play()

func _on_despawn_area_body_entered(body: Node2D) -> void:
	if body is Word:
		body.do_damage()
		particles.emitting = true

func _on_timer_timeout() -> void:
	var word = word_scene.instantiate()
	word.position = word_spawn_point.position
	add_child(word)
