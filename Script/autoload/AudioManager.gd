extends Node

const SAVE_PATH := "user://settings.cfg"

var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0

# --- Music player (1 node, di-reuse untuk semua BGM) ---
@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

# --- Pool SFX player, supaya beberapa SFX bisa main bersamaan tanpa saling memotong ---
var sfx_players: Array[AudioStreamPlayer] = []
const SFX_POOL_SIZE := 8

# --- Preload semua stream musik & SFX ---
const MUSIC := {
	"main_menu": preload("res://Assets/sound/music/2016_ Clement Panchout_ Life is full of Joy.wav"),
	"gameplay": preload("res://Assets/sound/music/Clement Panchout _ LJ_Tel_DnB.wav"),
	"minigame": preload("res://Assets/sound/music/Clement Panchout _ LJ_Tel_Breakbeat.wav"),
}

const SFX := {
	"button_click": preload("res://Assets/sound/sfx/click.wav"),
	"button_return": preload("res://Assets/sound/sfx/back.wav"),
	"jump": preload("res://Assets/sound/sfx/jump.wav"),
	"collect_point": preload("res://Assets/sound/sfx/point.wav"),
	"hit": preload("res://Assets/sound/sfx/hit.wav"),
	"game_over": preload("res://Assets/sound/sfx/game_over.wav"),
	"minigame_correct": preload("res://Assets/sound/sfx/mini_point.wav"),
	"minigame_wrong": preload("res://Assets/sound/sfx/hit.wav"),
}

var current_music_key: String = ""

func _ready() -> void:
	load_settings()
	_apply_all_volumes()

	music_player.bus = "Music"
	add_child(music_player)

	for i in range(SFX_POOL_SIZE):
		var p := AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		sfx_players.append(p)

# --- MUSIK ---
func play_music(key: String, fade_duration: float = 0.5) -> void:
	if not MUSIC.has(key):
		push_warning("Musik tidak ditemukan: " + key)
		return
	if current_music_key == key and music_player.playing:
		return

	current_music_key = key

	if music_player.playing:
		var tween := create_tween()
		tween.tween_property(music_player, "volume_db", -40.0, fade_duration)
		await tween.finished

	music_player.stream = MUSIC[key]
	music_player.volume_db = 0.0
	music_player.play()

func stop_music(fade_duration: float = 0.5) -> void:
	var tween := create_tween()
	tween.tween_property(music_player, "volume_db", -40.0, fade_duration)
	await tween.finished
	music_player.stop()
	current_music_key = ""

# --- SFX ---
func play_sfx(key: String) -> void:
	if not SFX.has(key):
		push_warning("SFX tidak ditemukan: " + key)
		return
	var player := _get_free_sfx_player()
	player.stream = SFX[key]
	player.play()

func _get_free_sfx_player() -> AudioStreamPlayer:
	for p in sfx_players:
		if not p.playing:
			return p
	return sfx_players[0] 

func set_master_volume(value: float) -> void:
	master_volume = value
	_apply_volume("Master", value)
	save_settings()

func set_music_volume(value: float) -> void:
	music_volume = value
	_apply_volume("Music", value)
	save_settings()

func set_sfx_volume(value: float) -> void:
	sfx_volume = value
	_apply_volume("SFX", value)
	save_settings()

func _apply_volume(bus_name: String, linear_value: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_value))
	AudioServer.set_bus_mute(bus_index, linear_value <= 0.0)

func _apply_all_volumes() -> void:
	_apply_volume("Master", master_volume)
	_apply_volume("Music", music_volume)
	_apply_volume("SFX", sfx_volume)

func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "master", master_volume)
	config.set_value("audio", "music", music_volume)
	config.set_value("audio", "sfx", sfx_volume)
	config.save(SAVE_PATH)

func load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)
	if err != OK:
		return
	master_volume = config.get_value("audio", "master", 1.0)
	music_volume = config.get_value("audio", "music", 1.0)
	sfx_volume = config.get_value("audio", "sfx", 1.0)
