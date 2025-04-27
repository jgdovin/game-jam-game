extends Node2D

@onready var press_particle_right: CPUParticles2D = $PressParticleRight
@onready var press_particle_left: CPUParticles2D = $PressParticleLeft
@onready var press_animation_player: AnimationPlayer = %PressAnimationPlayer
@onready var clang_sf: AudioStreamPlayer = %Clang
@onready var pshhh_sf: AudioStreamPlayer = %Pshhh

func _ready() -> void:
	press_animation_player.speed_scale = _get_difficulty_speed()
	Game.difficulty_increased.connect(_on_difficulty_increased)
	Game.game_ended.connect(_on_game_ended)

func _on_game_ended() -> void:
	press_animation_player.stop()
	

func play_press_particle(side: String) -> void:
	clang_sf.play()
	press_particle_right.emitting = true
	press_particle_left.emitting = true

func _on_difficulty_increased() -> void:
	press_animation_player.speed_scale = _get_difficulty_speed()

func _get_difficulty_speed() -> float:
	var difficulty = Game.state.difficulty
	# Scale from 0.2 to 1.0, with level 10 being the maximum
	var normalized_difficulty = clamp(difficulty / 20.0, 0.0, .5)
	return lerp(0.2, 1.0, normalized_difficulty)

func play_clang_sound_effect() -> void:
	clang_sf.play()

func play_pshhh_sound_effect() -> void:
	pshhh_sf.play()
