extends CanvasLayer

func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)

func _on_score_changed(new_score: int) -> void:
	$ScoreLabel.text = "SCORE: " + str(new_score / GameManager.SCORE_MODIFIER)
