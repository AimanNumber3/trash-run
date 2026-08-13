extends Control

@onready var data_grid: GridContainer = $TabelContainer/DataGrid
@onready var back_button: Button = $BackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	isi_tabel()

func isi_tabel() -> void:
	for child in data_grid.get_children():
		child.queue_free()
	
	var scores := LeaderboardManager.get_score()
	if scores.is_empty():
		var empty_label := Label.new()
		empty_label.text = "BELUM ADA SKOR"
		data_grid.add_child(empty_label)
		return
	
	for i in range(scores.size()):
		var entry: Dictionary = scores[i]
		var no_label := Label.new()
		no_label.text = str(i + 1)
		no_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var name_label := Label.new()
		name_label.text = str(entry.get("nama", "?"))
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		var score_label := Label.new()
		score_label.text = str(entry.get("skor", 0))
		score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		data_grid.add_child(no_label)
		data_grid.add_child(name_label)
		data_grid.add_child(score_label)

func _on_back_button_pressed() -> void:
	AudioManager.play_sfx("button_return")
	TransitionManager.change_scene("res://Scenes/main_menu.tscn")
