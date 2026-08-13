extends Node

const SAVE_PATH := "user://savegame.json"

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_game() -> void:
	var data := {
		"score": GameManager.score,
		"raw_distance": GameManager.raw_distance,
		"hearts": GameManager.hearts,
		"speed": GameManager.speed,
		"next_checkpoint_score": GameManager.next_checkpoint_score,
		"minigame_bonus_score": GameManager.minigame_bonus_score,
		"pending_trash_type": GameManager.pending_trash_type,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveManager: gagal membuka file untuk menulis")
		return
	file.store_string(JSON.stringify(data))
	file.close()

func load_game() -> bool:
	if not has_save():
		return false

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return false
	var content := file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(content)
	if not (parsed is Dictionary):
		return false

	GameManager.score = parsed.get("score", 0)
	GameManager.raw_distance = parsed.get("raw_distance", 0.0)
	GameManager.hearts = parsed.get("hearts", GameManager.MAX_HEARTS)
	GameManager.speed = parsed.get("speed", GameManager.START_SPEED)
	GameManager.next_checkpoint_score = parsed.get("next_checkpoint_score", GameManager.CHECKPOINT_INTERVAL)
	GameManager.minigame_bonus_score = parsed.get("minigame_bonus_score", 0)
	GameManager.pending_trash_type = parsed.get("pending_trash_type", "")
	GameManager.checkpoint_zone_active = false
	GameManager.game_running = false

	return true

func clear_save() -> void:
	if has_save():
		DirAccess.remove_absolute(SAVE_PATH)
