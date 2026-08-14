extends Node

var score: int = 0
signal score_changed(new_score)

var raw_distance: float = 0.0
const METER_MODIFIER: int = 18
signal distance_changed(new_meters)

var checkpoint_zone_active: bool = false
var next_checkpoint_score: int = 500
const CHECKPOINT_INTERVAL: int = 500

var speed: float = 0.0
var screen_size: Vector2i
var game_running: bool = false

var hearts: int = 3
const MAX_HEARTS: int = 3

const START_SPEED: float = 300.0
const MAX_SPEED: float = 500.0
const GRAVITY: float = 2500

var pending_trash_type: String = ""
var minigame_bonus_score: int = 0
var returning_from_minigame: bool = false

signal heart_changed(new_hearts)
signal checkpoint_zone_reached
signal checkpoint_reached(trash_type)

func reset_run() -> void:
	score = 0
	raw_distance = 0.0
	hearts = MAX_HEARTS
	speed = START_SPEED
	game_running = false
	next_checkpoint_score = CHECKPOINT_INTERVAL
	checkpoint_zone_active = false
	score_changed.emit(score)
	distance_changed.emit(0)
	heart_changed.emit(hearts)

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

func add_distance(amount: float) -> void:
	raw_distance += amount
	var meters := int(raw_distance / METER_MODIFIER)
	distance_changed.emit(meters)
	
	var cond_game_running: bool = game_running
	var cond_not_zone_active: bool = not checkpoint_zone_active
	var cond_meters_reached: bool = meters >= next_checkpoint_score
	
	if cond_game_running and cond_not_zone_active and cond_meters_reached:
		checkpoint_zone_active = true
		checkpoint_zone_reached.emit()

func trigger_checkpoint() -> void:
	if not checkpoint_zone_active:
		return
	game_running = false
	pending_trash_type = ["organik", "anorganik"].pick_random()
	next_checkpoint_score += CHECKPOINT_INTERVAL
	checkpoint_zone_active = false
	checkpoint_reached.emit(pending_trash_type)

func lose_heart() -> void:
	hearts -= 1
	heart_changed.emit(hearts)
	if hearts <= 0:
		get_tree().call_group("world", "game_over")

func increase_speed(delta: float) -> void:
	speed = min(speed + delta, MAX_SPEED)
