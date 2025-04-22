extends Control

@onready var start_button: Button = %Start
@onready var options_button: Button = %Options
@onready var exit_button: Button = %Exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _on_start_pressed() -> void:
	References.game_controller.change_gui_scene(References.game_controller.score)
	References.game_controller.change_2d_scene(References.game_controller.factory)
	Game.start_game()

func _on_exit_pressed() -> void:
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
