extends Node

const SAVE_PATH := "user://scoreboard.json"
const MAX_ENTRIES := 10

signal leaderboard_update

func submit_score(player_name: String, final_score: int) -> void:
	var clean_name := player_name.strip_edges()
	if clean_name.is_empty():
		clean_name = "Player"
	var scores := load_scores()
	var new_name := {"nama": clean_name, "skor": final_score}
	scores.append(new_name)
	
	scores.sort_custom(func(a, b): return a["skor"] > b["skor"])
	var top_score := scores.slice(0, MAX_ENTRIES)
	
	save_scores(top_score)
	leaderboard_update.emit()

func save_scores(scores: Array) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(scores))
	file.close()

func get_score() -> Array:
	return load_scores()

func load_scores() -> Array:
	if not FileAccess.file_exists(SAVE_PATH):
		return []
	
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var isi := file.get_as_text()
	file.close()
	
	var parse_data = JSON.parse_string(isi)
	
	if parse_data is Array:
		return parse_data
	else:
		return []
