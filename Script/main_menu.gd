extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var option_button: Button = $VBoxContainer/OptionButton
@onready var credit_button: Button = $VBoxContainer/HBoxContainer/CreditButton
@onready var score_button: Button = $VBoxContainer/HBoxContainer/ScoreButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

func _ready() -> void:
	AudioManager.play_music("main_menu")
	start_button.pressed.connect(_on_start_button_pressed)
	continue_button.visible = SaveManager.has_save()
	option_button.pressed.connect(_on_option_button_pressed)
	credit_button.pressed.connect(_on_credit_button_pressed)
	score_button.pressed.connect(_on_score_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _on_start_button_pressed() -> void:
	AudioManager.play_sfx("button_click")
	TransitionManager.change_scene("res://Scenes/world.tscn")

func _on_continue_button_pressed() -> void:
	AudioManager.play_sfx("button_click")
	if SaveManager.load_game():
		GameManager.returning_from_minigame = true
		TransitionManager.change_scene("res://Scenes/world.tscn")

func _on_option_button_pressed() -> void:
	AudioManager.play_sfx("button_click")
	TransitionManager.change_scene("res://Scenes/menu/options.tscn")

func _on_credit_button_pressed() -> void:
	AudioManager.play_sfx("button_click")
	TransitionManager.change_scene("res://Scenes/menu/credit.tscn")

func _on_score_button_pressed() -> void:
	AudioManager.play_sfx("button_click")
	TransitionManager.change_scene("res://Scenes/menu/leaderboard.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
