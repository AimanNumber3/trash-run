extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var option_button: Button = $VBoxContainer/OptionButton
@onready var credit_button: Button = $VBoxContainer/HBoxContainer/CreditButton
@onready var score_button: Button = $VBoxContainer/HBoxContainer/ScoreButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	option_button.pressed.connect(_on_option_button_pressed)
	credit_button.pressed.connect(_on_credit_button_pressed)
	score_button.pressed.connect(_on_score_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_option_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu/options.tscn")

func _on_credit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu/credit.tscn")

func _on_score_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu/leaderboard.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
