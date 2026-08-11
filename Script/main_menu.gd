extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var option_button: Button = $VBoxContainer/OptionButton
@onready var credit_button: Button = $VBoxContainer/HBoxContainer/CreditButton
@onready var score_button: Button = $VBoxContainer/HBoxContainer/ScoreButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_option_button_pressed() -> void:
	pass # Replace with function body.

func _on_credit_button_pressed() -> void:
	pass # Replace with function body.

func _on_score_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	pass # Replace with function body.
