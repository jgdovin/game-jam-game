# This file is part of QAudio, a Godot audio library.
# Copyright (C) 2025 Ducking Games Studio
class_name AudioStreamBankPool extends AudioStreamPlayerPool

"""
AudioStreamBankPool is a pool of AudioStreamPlayerPooling 
nodes that can be used to play audio streams from an 
AudioStreamBank.

This is meant to be set as an Autoload in the project settings.
"""

@export var bank: AudioStreamBank

## retrieve an audiostream from the bank by name
func retrieve_stream(_n: String) -> AudioStream:
  if bank == null:
    push_error("AudioStreamBank not set!")
    return null

  return bank.retrieve_stream(_n)

## retrieve the bus for a stream in the bank
func retrieve_bus() -> String:
  if bank == null:
    push_error("AudioStreamBank not set!")
    return AudioStreamPlayerPool.DefaultBus

  return bank.BankBus

## stab plays an audio stream immediately
func stab(_n: String, _v: float = DefaultVolume) -> void:
  var stream: AudioStream = retrieve_stream(_n)
  if stream == null:
    return

  _stab(stream, bank.BankBus, _v)

## stab_random_Speed plays an audio stream immediately
## with a random speed within the given range
func stab_random_Speed(_n: String, _v: float = DefaultVolume, _min_speed: float = 0.5, _max_speed: float = 1.5) -> void:
  var stream: AudioStream = retrieve_stream(_n)
  if stream == null:
    return

  _stab_random_Speed(stream, bank.BankBus, _v, _min_speed, _max_speed)

## stab_random_pitch plays an audio stream immediately
## with a random pitch within the given range
func stab_random_pitch(_n: String, _v: float = DefaultVolume, _min_pitch: float = 0.5, _max_pitch: float = 1.5) -> void:
  var stream: AudioStream = retrieve_stream(_n)
  if stream == null:
    return

  _stab_random_pitch(stream, bank.BankBus, _v, _min_pitch, _max_pitch)