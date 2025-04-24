# This file is part of QAudio, a Godot audio library.
# Copyright (C) 2025 Ducking Games Studio

class_name AudioStreamPlayerPooling extends AudioStreamPlayer

"""
An AudioStreamPlayerPooling is an AudioStreamPlayer modified for use in an AudioStreamPlayerPool.


"""

## Whether or not this pooling player will persist when it's stream is finished
@export var persistent: bool


func _init(persist: bool = true) -> void:
	persistent = persist

func reset() -> void:
	stream = null
	bus = "Master"
	volume_db = linear_to_db(1.0)

func acquire(Stream: AudioStream, Bus: String) -> void:
	stream = Stream
	bus = Bus
