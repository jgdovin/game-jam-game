extends Control

@onready var start_button: Button = %Start
@onready var options_button: Button = %Options
@onready var exit_button: Button = %Exit

@onready var leaderboard_button: Button = %Leaderboard
@onready var credits_button: Button = %Credits
@onready var credits_panel: Control = %CreditsPanel
@onready var close_credits_button: Button = %CloseCredits

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	credits_panel.visible = false
	close_credits_button.pressed.connect(_on_credits_pressed)
	leaderboard_button.pressed.connect(_on_leaderboard_pressed)

func _on_leaderboard_pressed() -> void:
	References.game_controller.load_leaderboard()

func _on_credits_pressed() -> void:
	credits_panel.visible = !credits_panel.visible

func _on_start_pressed() -> void:
	References.game_controller.load_factory()
	Game.start_game()

func _on_exit_pressed() -> void:
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
