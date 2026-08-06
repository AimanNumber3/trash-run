extends Node2D

@export var sampahs: Array[PackedScene]

@onready var markers: Marker2D = $Marker2D
@onready var markers2: Marker2D = $Marker2D2

func _on_timer_timeout() -> void:
	if not GameManager.game_running:
		return
	var random_sampahs: PackedScene = sampahs.pick_random()
	var random_sampah_instance: Node = random_sampahs.instantiate()
	add_child(random_sampah_instance)
	var chosen_marker = [markers, markers2].pick_random()
	
	random_sampah_instance.position = chosen_marker.position
