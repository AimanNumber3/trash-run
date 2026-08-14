extends Control

@onready var back_button: Button = $VBoxContainer/BackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)

func _on_back_button_pressed() -> void:
	AudioManager.play_sfx("button_return")
	TransitionManager.change_scene("res://Scenes/main_menu.tscn")
