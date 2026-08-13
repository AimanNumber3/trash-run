extends Area2D

@export var fall_speed: float = 250.0
@export var item_category: String = "organik"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += fall_speed * delta
	if position.y > 700:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("catcher"):
		if item_category == GameManager.pending_trash_type:
			AudioManager.play_sfx("minigame_correct")
			GameManager.minigame_bonus_score += 5
		else:
			AudioManager.play_sfx("minigame_wrong")
			GameManager.minigame_bonus_score = max(0, GameManager.minigame_bonus_score - 10)
		queue_free()
