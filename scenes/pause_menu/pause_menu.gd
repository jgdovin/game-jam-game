extends Control

@onready var resume_button: Button = %Resume
@onready var quit_button: Button = %Quit
@onready var options_button: Button = %Options
@onready var panel_container: PanelContainer = %PanelContainer
@onready var animation_player: AnimationPlayer = %AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resume_button.pressed.connect(resume)
	quit_button.pressed.connect(quit)
	options_button.pressed.connect(options)

func options() -> void:
	pass

func quit() -> void:
	Game.end_game(false)
	References.game_controller.load_main_menu()

func resume() -> void:
	get_tree().paused = false
	animation_player.play_backwards("blur")
func pause() -> void:
	get_tree().paused = true
	animation_player.play("blur")

func test_esc():
	if Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()
		return
	
	if Input.is_action_just_pressed("esc") and not get_tree().paused:
		pause()
		return

func _process(_delta: float) -> void:
	test_esc()
