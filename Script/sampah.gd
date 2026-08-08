extends Area2D

func _physics_process(delta: float) -> void:
	if not GameManager.game_running:
		return
	position.x -= GameManager.speed * delta
