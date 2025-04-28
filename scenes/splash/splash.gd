extends Control

@onready var egg_crack: AnimatedSprite2D = %EggCrack
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	egg_crack.animation_finished.connect(_on_egg_crack_animation_finished)


func _on_egg_crack_animation_finished() -> void:
	animation_player.play("crack")

func play_egg_crack_animation() -> void:
	egg_crack.play("default")
