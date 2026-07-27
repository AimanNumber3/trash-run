extends Node

var score: int = 0
var speed: float = 0.0
var screen_size: Vector2i
var game_running: bool = false

var hearts: int = 3
const MAX_HEARTS: int = 3

const START_SPEED: float = 300.0
const MAX_SPEED: float = 500.0
const SCORE_MODIFIER: int = 18
const SPEED_MODIFIER: int = 50

var next_checkpoint_score: int = 500
const CHECKPOINT_INTERVAL: int = 500
var pending_trash_type: String = ""
var minigame_bonus_score: int = 0
var returning_from_minigame: bool = false

signal score_changed(new_score)
signal heart_changed(new_hearts)
signal checkpoint_reached(trash_type)

func reset_run() -> void:
	score = 0
	hearts = MAX_HEARTS
	speed = START_SPEED
	game_running = false
	next_checkpoint_score = CHECKPOINT_INTERVAL
	score_changed.emit(score)
	heart_changed.emit(hearts)

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)
	if game_running and (score / SCORE_MODIFIER) >= next_checkpoint_score:
		trigger_checkpoint()

func trigger_checkpoint() -> void:
	game_running = false
	pending_trash_type = ["organik", "anorganik"].pick_random()
	next_checkpoint_score += CHECKPOINT_INTERVAL
	checkpoint_reached.emit(pending_trash_type)

func lose_heart() -> void:
	hearts -= 1
	heart_changed.emit(hearts)
	if hearts <= 0:
		get_tree().call_group("world", "game_over")

func increase_speed(delta: float) -> void:
	speed = min(speed + delta, MAX_SPEED)
