extends Node2D

@onready var failed_word_sound: AudioStreamPlayer = $FailedWord
@onready var completed_sound: AudioStreamPlayer = $Completed
@onready var typo_sound: AudioStreamPlayer = $Typo
@onready var typo_music: AudioStreamPlayer = $TypoMusic
@onready var game_music: AudioStreamPlayer = $GameMusic

func play_failed_word() -> void:
	failed_word_sound.play()

func play_completed() -> void:
	completed_sound.play()

func play_typo() -> void:
	typo_sound.play()

func play_typo_music() -> void:
	game_music.stop()
	typo_music.play()

func play_game_music() -> void:
	typo_music.stop()
	game_music.play()

func stop_game_music() -> void:
	game_music.stop()
