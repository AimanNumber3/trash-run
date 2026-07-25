extends Node2D

const PLAYER_START_POS := Vector2(150, 485)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.screen_size = get_window().size
	$GameOver.get_node("Button").pressed.connect(new_game)
	new_game()

func new_game():
	get_tree().paused = false
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$HUD.get_node("StartLabel").show()
	$GameOver.hide()
	GameManager.reset_run()

func _process(delta: float) -> void:
	if GameManager.game_running:
		GameManager.add_score(int(GameManager.speed * delta))
		if GameManager.speed > GameManager.MAX_SPEED:
			GameManager.speed = GameManager.MAX_SPEED
		print(GameManager.speed)
	else:
		if Input.is_action_pressed("ui_accept"):
			GameManager.game_running = true
			$HUD.get_node("StartLabel").hide()

func game_over():
	get_tree().paused = true
	$GameOver.show()
	GameManager.game_running = false
