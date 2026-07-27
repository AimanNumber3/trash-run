extends CanvasLayer

@onready var heart_container: HBoxContainer = $HeartContainer

func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.heart_changed.connect(_on_heart_changed)

func _on_score_changed(new_score: int) -> void:
	$ScoreLabel.text = "SCORE: " + str(new_score / GameManager.SCORE_MODIFIER)

func _on_heart_changed(new_hearts: int) -> void:
	var heart_icons = heart_container.get_children()
	for i in range(heart_icons.size()):
		heart_icons[i].visible = i < new_hearts
