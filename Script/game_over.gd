extends CanvasLayer

@onready var final_score_label: Label = $HBoxContainer/VBoxContainer/FinalScoreLabel
@onready var name_input: LineEdit = $HBoxContainer/VBoxContainer/NameInput
@onready var submit_button: Button = $HBoxContainer/VBoxContainer/SubmitButton
@onready var leaderboard_list: VBoxContainer = $HBoxContainer/VBoxContainer/LeaderboardList

var score_submit: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	submit_button.pressed.connect(_on_submit_button_pressed)

func _on_submit_button_pressed() -> void:
	if score_submit:
		return
	LeaderboardManager.submit_score(name_input.text, GameManager.score)
	score_submit = true
	name_input.hide()
	submit_button.hide()
	refresh_leaderboard()

func show_game_over() -> void:
	score_submit = false
	final_score_label.text = "SKOR AKHIR: " + str(GameManager.score)
	name_input.text = ""
	name_input.show()
	submit_button.show()
	refresh_leaderboard()
	show()

func refresh_leaderboard() -> void:
	for child in leaderboard_list.get_children():
		child.queue_free()
	
	var scores := LeaderboardManager.get_score()
	if scores.is_empty():
		var empty_label := Label.new()
		empty_label.text = "Belum ada skor."
		leaderboard_list.add_child(empty_label)
		return
	
	for i in range(scores.size()):
		var entry: Dictionary = scores[i]
		var row := Label.new()
		row.text = str(i + 1) + ". " + str(entry.get("nama", "?")) + " - " + str(entry.get("score", 0))
		leaderboard_list.add_child(row)

func _on_menu_button_pressed() -> void:
	AudioManager.play_sfx("button_return")
	TransitionManager.change_scene("res://Scenes/main_menu.tscn")
