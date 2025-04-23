extends Node2D
class_name GameController

@onready var world_2d: Node2D = $World2D
@onready var gui: CanvasLayer = $GUI

var current_2d_scene
var current_gui_scene

@onready var main_menu_scene: PackedScene = preload("res://scenes/main_menu/main_menu.tscn")
@onready var factory_scene: PackedScene = preload("res://scenes/factory/factory.tscn")
@onready var summary_scene: PackedScene = preload("res://scenes/summary/summary.tscn")

var main_menu: Control
var factory: Node2D
var summary: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	References.game_controller = self
	main_menu = main_menu_scene.instantiate()
	factory = factory_scene.instantiate()
	summary = summary_scene.instantiate()
	load_main_menu()

func load_main_menu() -> void:
	SoundManager.stop_game_music()
	if current_gui_scene:
		current_gui_scene.queue_free()
		current_gui_scene = null
	if current_2d_scene:
		current_2d_scene.queue_free()
		current_2d_scene = null
	var instance = main_menu.duplicate()
	gui.add_child(instance)
	current_gui_scene = instance

func set_gui_empty() -> void:
	gui.remove_child(current_gui_scene)
	current_gui_scene = null

func set_2d_empty() -> void:
	world_2d.remove_child(current_2d_scene)
	current_2d_scene = null

func load_factory() -> void:
	if current_2d_scene:
		current_2d_scene.queue_free()
		current_2d_scene = null
	if current_gui_scene:
		current_gui_scene.queue_free()
		current_gui_scene = null
	var factory_instance = factory.duplicate()
	world_2d.add_child(factory_instance)
	current_2d_scene = factory_instance
	Game.start_game()

func load_summary() -> void:
	print("Loading summary")
	if current_gui_scene:
		current_gui_scene.queue_free()
		current_gui_scene = null
	var summary_instance = summary.duplicate()
	gui.add_child(summary_instance)
	print(summary_instance)
	current_gui_scene = summary_instance
