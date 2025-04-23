extends Node2D

@onready var base: Node2D = $Base
@export var is_end: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_end:
		base.visible = false