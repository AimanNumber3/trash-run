extends Node

var score: int = 0
var speed: float = 0.0
var screen_size: Vector2i
var game_running: bool = false

const START_SPEED: float = 300.0
const MAX_SPEED: float = 500.0
const SCORE_MODIFIER: int = 18
const SPEED_MODIFIER: int = 50

signal score_changed(new_score)

func _ready() -> void:
	if game_running:
		speed = START_SPEED + score / SCORE_MODIFIER
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true

func reset_run() -> void:
	score = 0
	speed = START_SPEED + score / SCORE_MODIFIER
	score_changed.emit(score)

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

func increase_speed(delta: float) -> void:
	speed = min(speed + delta, MAX_SPEED)
