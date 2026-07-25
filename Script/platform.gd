extends StaticBody2D

func _physics_process(delta: float) -> void:
	position.x -= GameManager.speed * delta
