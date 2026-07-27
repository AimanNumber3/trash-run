extends Node2D

const PLAYER_START_POS := Vector2(150, 485)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("world")
	GameManager.screen_size = get_window().size
	$GameOver.get_node("Button").pressed.connect(_on_restart_pressed)
	GameManager.checkpoint_reached.connect(_on_checkpoint_reached)
	
	if GameManager.returning_from_minigame:
		GameManager.returning_from_minigame = false
		resume_game()
	else:
		new_game()

func new_game():
	get_tree().paused = false
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$HUD.get_node("StartLabel").show()
	$GameOver.hide()
	GameManager.reset_run()

func resume_game():
	get_tree().paused = false
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$HUD.get_node("StartLabel").hide()
	$GameOver.hide()
	GameManager.game_running = true

func _process(delta: float) -> void:
	if GameManager.game_running:
		GameManager.add_score(int(GameManager.speed * delta))
		if GameManager.speed > GameManager.MAX_SPEED:
			GameManager.speed = GameManager.MAX_SPEED
	else:
		if Input.is_action_pressed("ui_accept"):
			GameManager.game_running = true
			$HUD.get_node("StartLabel").hide()

func _on_checkpoint_reached(trash_type: String) -> void:
	$CheckpointPopup.show_popup(trash_type)

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func game_over():
	get_tree().paused = true
	$GameOver.show()
	GameManager.game_running = false
