extends HBoxContainer
const CHAR_SET: String = "0123456789ABCDEFGHIJKLMNOPQRSTUVW"

@export var emoji_display_override: String = ""
@onready var emoji_display_base: TextureRect = $EmojiDisplayBase

func _ready() -> void:
	if emoji_display_override:
		print("Setting player emojis to override: ", emoji_display_override)
		Game.player_emojis = emoji_display_override
		_setup_emojis()
		return

	if Game.player_emojis:
		_setup_emojis()
		return
	print("No player emojis found, generating random ones")
	# Generate random emojis if we don't have any
	for i in range(5):
		Game.player_emojis += CHAR_SET[randi() % CHAR_SET.length()]
	_setup_emojis()

func set_emoji_display_override(override: String) -> void:
	emoji_display_override = override
	Game.player_emojis = override
	_setup_emojis()


func _setup_emojis() -> void:
	for child in get_children():
		if child.visible:
			child.queue_free()
	
	for i in Game.player_emojis:
		var new_emoji_texture = emoji_display_base.duplicate()
		new_emoji_texture.texture = load("res://assets/emojis/" + i.to_upper() + ".png")
		new_emoji_texture.visible = true
		add_child(new_emoji_texture)
