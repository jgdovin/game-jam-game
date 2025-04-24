extends Area2D

@onready var display: Control = %Display
@export var label_text: String
@onready var label: Label = %Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = label_text
	display.visible = false
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)

func _on_input_event(event: InputEvent) -> void:
	if event is InputEventMouse:
		print(event)

func _on_mouse_entered() -> void:
	display.visible = true

func _on_mouse_exited() -> void:
	display.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
