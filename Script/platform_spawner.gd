extends Node2D

@export var platforms: Array[PackedScene]

@onready var marker: Marker2D = $Marker2D

func _on_timer_timeout() -> void:
	if not GameManager.game_running:
		return
	var random_platform: PackedScene = platforms.pick_random()
	var random_platform_instance: Node = random_platform.instantiate()
	add_child(random_platform_instance)
	
	random_platform_instance.position = marker.position
