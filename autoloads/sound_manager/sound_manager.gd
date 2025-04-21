extends Node2D

@onready var failed_word_sound: AudioStreamPlayer = $FailedWord
@onready var completed_sound: AudioStreamPlayer = $Completed
@onready var typo_sound: AudioStreamPlayer = $Typo
func play_failed_word() -> void:
	failed_word_sound.play()

func play_completed() -> void:
	completed_sound.play()

func play_typo() -> void:
	typo_sound.play()
