extends Node2D
class_name GameController

@onready var world_2d: Node2D = $World2D
@onready var gui: CanvasLayer = $GUI

var current_2d_scene
var current_gui_scene


@onready var main_menu: Control = $GUI/MainMenu
@onready var score: Control = $GUI/Score
@onready var GUI_SCENES = [main_menu, score]

@onready var factory: Node2D = $World2D/Factory
@onready var WORLD_SCENES = [factory]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	References.game_controller = self
	current_gui_scene = $GUI/MainMenu
	world_2d.remove_child(factory)
	gui.remove_child(score)

func set_gui_empty() -> void:
	gui.remove_child(current_gui_scene)
	current_gui_scene = null

func set_2d_empty() -> void:
	world_2d.remove_child(current_2d_scene)
	current_2d_scene = null

func change_gui_scene(new_scene: Control, delete: bool = true, keep_running: bool = false) -> void:
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)
	gui.add_child(new_scene)
	current_gui_scene = new_scene

func _handle_gui_deletion(delete: bool) -> void:
	if delete:
		current_gui_scene.queue_free()

func change_2d_scene(new_scene: Node2D, delete: bool = true, keep_running: bool = false) -> void:
	if current_2d_scene != null:
		if delete:
			current_2d_scene.queue_free()
		elif keep_running:
			current_2d_scene.visible = false
		else:
			world_2d.remove_child(current_2d_scene)
	world_2d.add_child(new_scene)
	current_2d_scene = new_scene	

