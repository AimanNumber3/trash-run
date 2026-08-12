extends Control

@onready var master_slider: HSlider = $VBoxContainer/MasterSlider
@onready var music_slider: HSlider = $VBoxContainer/MusicSlider
@onready var sfx_slider: HSlider = $VBoxContainer/SFXSlider
@onready var back_button: Button = $VBoxContainer/BackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_slider.value = AudioManager.master_volume
	music_slider.value = AudioManager.music_volume
	sfx_slider.value = AudioManager.sfx_volume
	
	master_slider.value_changed.connect(_on_master_slider_changed)
	music_slider.value_changed.connect(_on_music_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	back_button.pressed.connect(_on_back_button_pressed)

func _on_master_slider_changed(value: float) -> void:
	AudioManager.set_master_volume(value)

func _on_music_slider_changed(value: float) -> void:
	AudioManager.set_music_volume(value)

func _on_sfx_slider_changed(value: float) -> void:
	AudioManager.set_sfx_value(value)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
