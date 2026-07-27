extends CharacterBody2D

@export var speed: float = 500.0
@export var min_x: float = 50.0
@export var max_x: float = 1152.0

func _ready() -> void:
	add_to_group("catcher")

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	move_and_slide()
	position.x = clamp(position.x, min_x, max_x)
