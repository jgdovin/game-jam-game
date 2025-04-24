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
