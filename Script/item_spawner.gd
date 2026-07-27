extends Node2D

@export var items: Array[PackedScene]
@onready var markers: Array[Marker2D] = [$marker1, $marker2, $marker3]

func _on_timer_timeout() -> void:
	var random_item: PackedScene = items.pick_random()
	var instance: Node = random_item.instantiate()
	add_child(instance)
	instance.position = markers.pick_random().position
