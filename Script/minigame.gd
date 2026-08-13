extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music("minigame")
	GameManager.minigame_bonus_score = 0
	$MinigameHUD.get_node("TargetLabel").text = GameManager.pending_trash_type
	$MinigameTimer.timeout.connect(_on_minigame_timer_timeout)
	$MinigameTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$MinigameHUD.get_node("TimeLabel").text = "WAKTU: " + str(int($MinigameTimer.time_left))
	$MinigameHUD.get_node("ScoreContainer/BonusLabel").text = "BONUS: " + str(GameManager.minigame_bonus_score)
	$MinigameHUD.get_node("ScoreContainer/ScoreLabel").text = "SKOR: " + str(GameManager.score + GameManager.minigame_bonus_score)

func _on_minigame_timer_timeout() -> void:
	end_minigame()

func end_minigame() -> void:
	GameManager.add_score(GameManager.minigame_bonus_score)
	GameManager.minigame_bonus_score = 0
	GameManager.returning_from_minigame = true
	TransitionManager.change_scene("res://Scenes/world.tscn")
