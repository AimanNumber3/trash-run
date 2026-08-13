extends Node2D

const PLAYER_START_POS := Vector2(150, 485)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music("gameplay")
	add_to_group("world")
	GameManager.screen_size = get_window().size
	$GameOver.get_node("HBoxContainer/VBoxContainer2/RestartButton").pressed.connect(on_restart_pressed)
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
	$HUD.get_node("StartLabel").show()
	$GameOver.hide()
	GameManager.game_running = false

func hitung_mundur() -> void:
	for i in [3,2,1]:
		$HUD.get_node("CoundownLabel").text = str(i)
		$HUD.get_node("CoundownLabel").show()
		await get_tree().create_timer(1.0).timeout
	%HUD.get_node("CoundownLabel").hide()

func _process(delta: float) -> void:
	if GameManager.game_running:
		GameManager.add_distance(GameManager.speed * delta)
		GameManager.increase_speed(10.0 * delta)
	else:
		if Input.is_action_pressed("ui_accept"):
			GameManager.game_running = true
			$HUD.get_node("StartLabel").hide()

func _on_checkpoint_reached(trash_type: String) -> void:
	$CheckpointPopup.show_popup(trash_type)

func on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func game_over():
	get_tree().paused = true
	AudioManager.play_sfx("game_over")
	AudioManager.stop_music()
	$GameOver.show_game_over()
	GameManager.game_running = false
	SaveManager.clear_save()
