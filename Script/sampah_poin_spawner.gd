extends Node2D

@export var poins: Array[PackedScene]

@onready var markers: Marker2D = $Marker2D
@onready var markers2: Marker2D = $Marker2D2

func _on_timer_timeout() -> void:
	if not GameManager.game_running:
		return
	var random_poins: PackedScene = poins.pick_random()
	var random_poin_instance: Node = random_poins.instantiate()
	add_child(random_poin_instance)
	var chosen_marker = [markers, markers2].pick_random()
	
	random_poin_instance.position = chosen_marker.position
