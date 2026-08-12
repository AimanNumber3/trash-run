extends Node

const SAVE_PATH := "user://settings.cfg"

var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_settings()
	apply_all_volumes()

func set_master_volume(value: float) -> void:
	master_volume = value
	apply_volume("Master", value)
	save_settings()

func set_music_volume(value: float) -> void:
	music_volume = value
	apply_volume("Music", value)
	save_settings()

func set_sfx_value(value: float) -> void:
	sfx_volume = value
	apply_volume("SFX", value)
	save_settings()

func apply_volume(bus_name: String, linear_value: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_value))
	AudioServer.set_bus_mute(bus_index, linear_value <= 0.0)

func apply_all_volumes() -> void:
	apply_volume("Master", master_volume)
	apply_volume("Music", music_volume)
	apply_volume("SFX", sfx_volume)

func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "master", master_volume)
	config.set_value("audio", "music", music_volume)
	config.set_value("audio", "sfx", sfx_volume)

func load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)
	if err != OK:
		return
	master_volume = config.get_value("audio", "master", 1.0)
	music_volume = config.get_value("audio", "music", 1.0)
	sfx_volume = config.get_value("audio", "sfx", 1.0)
