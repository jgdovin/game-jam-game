extends Node2D
class_name GameController

@onready var world_2d: Node2D = $World2D
@onready var gui: CanvasLayer = $GUI

var current_2d_scene
var current_gui_scene

@onready var main_menu_scene: PackedScene = preload("res://scenes/main_menu/main_menu.tscn")
@onready var factory_scene: PackedScene = preload("res://scenes/factory/factory.tscn")
@onready var leaderboard_scene: PackedScene = preload("res://scenes/leaderboard/leaderboard.tscn")
@onready var splash_screen_scene: PackedScene = preload("res://scenes/splash_screen/splash_screen.tscn")
var main_menu: Control
var factory: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	References.game_controller = self
	main_menu = main_menu_scene.instantiate()
	factory = factory_scene.instantiate()
	load_splash_screen()

func load_leaderboard() -> void:
	if current_gui_scene:
		current_gui_scene.queue_free()
		current_gui_scene = null
	var leaderboard_instance = leaderboard_scene.instantiate()
	gui.call_deferred("add_child", leaderboard_instance)
	current_gui_scene = leaderboard_instance

func load_splash_screen() -> void:
	if current_gui_scene:
		current_gui_scene.queue_free()
		current_gui_scene = null
	var splash_screen_instance = splash_screen_scene.instantiate()
	gui.call_deferred("add_child", splash_screen_instance)
	current_gui_scene = splash_screen_instance

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
