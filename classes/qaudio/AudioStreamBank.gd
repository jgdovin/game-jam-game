# This file is part of QAudio, a Godot audio library.
# Copyright (C) 2025 Ducking Games Studio
class_name AudioStreamBank extends Resource

"""
AudioStreamBank is a resource that contains a collection of 
audio streams and their associated properties.
"""

@export var BankName: String
@export var BankBus: String = AudioStreamPlayerPool.DefaultBus
@export var Bank: Dictionary[String, AudioStream]

func has(_n: String) -> bool:
  return Bank.has(_n)

func retrieve_stream(_n: String) -> AudioStream:
  if has(_n):
    return Bank[_n]
  else:
    push_error("AudioStream: " + _n + " not found in bank: " + BankName)
    return null
