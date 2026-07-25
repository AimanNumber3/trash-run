extends ParallaxBackground

@export var speed_multiplier: float = 0.8

func _process(delta: float) -> void:
	scroll_base_offset.x -= GameManager.speed * speed_multiplier * delta
