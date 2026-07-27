extends CanvasLayer

@onready var label: Label = $VBoxContainer/Label
@onready var yes_button: Button = $VBoxContainer/YesButton
@onready var no_button: Button = $VBoxContainer/NoButton

func _ready() -> void:
	hide()

func show_popup(trash_type: String) -> void:
	label.text = "Setor sampah %s?" % trash_type
	get_tree().paused = true
	show()

func _on_yes_button_pressed() -> void:
	print("yes")
	hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/minigame.tscn")

func _on_no_button_pressed() -> void:
	print("no")
	hide()
	get_tree().paused = false
	GameManager.game_running = true
