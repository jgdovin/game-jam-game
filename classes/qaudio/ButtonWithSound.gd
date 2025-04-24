# This file is part of QAudio, a Godot audio library.
# Copyright (C) 2025 Ducking Games Studio
class_name ButtonWithSound extends Button

@export var ui_hover: String = "hover"
@export var ui_click: String = "click"
@export var ui_hover_disabled: String = "hover_disabled"
@export var ui_disabled: String = "disabled"

"""
ButtonWithSound is an opinionated Button that plays a 
sound when pressed or hovered over.
"""

func _ready() -> void:
  mouse_entered.connect(_hover)
  button_up.connect(_click)

func _gui_input(event: InputEvent) -> void:
  if event is InputEventMouseButton and disabled:
    UIPool.stab(ui_disabled)

func _hover() -> void:
  if not disabled:
    pass
    UIPool.stab(ui_hover)
  else:
    UIPool.stab(ui_hover_disabled)

func _click() -> void:
  if not disabled:
    UIPool.stab(ui_click)
