extends CanvasLayer

@onready var heart_container: HBoxContainer = $HeartContainer

func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.distance_changed.connect(_on_distance_changed)
	GameManager.heart_changed.connect(_on_heart_changed)
	
	_on_score_changed(GameManager.score)
	_on_distance_changed(int(GameManager.raw_distance / GameManager.METER_MODIFIER))
	_on_heart_changed(GameManager.hearts)

func _on_score_changed(new_score: int) -> void:
	$ScoreContainer/ScoreLabel.text = "SKOR: " + str(new_score)

func _on_distance_changed(new_meters: int) -> void:
	$ScoreContainer/MeterLabel.text = "JARAK: " + str(new_meters)

func _on_heart_changed(new_hearts: int) -> void:
	var heart_icons = heart_container.get_children()
	for i in range(heart_icons.size()):
		heart_icons[i].visible = i < new_hearts
