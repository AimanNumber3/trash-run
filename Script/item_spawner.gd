extends Node2D

@export var items: Array[PackedScene]
@onready var markers: Array[Marker2D] = [$marker1, $marker2, $marker3, $marker4]

var jenis_sampah: Dictionary = {}

func _ready() -> void:
	petunjuk_kategori()

func petunjuk_kategori() -> void:
	jenis_sampah.clear()
	for scene in items:
		var temp: Node = scene.instantiate()
		var category: String = temp.item_category
		if not jenis_sampah.has(category):
			jenis_sampah[category] = []
		jenis_sampah[category].append(scene)
		temp.queue_free()

func get_scenes_for_category(category: String) -> Array:
	return jenis_sampah.get(category, [])

func _on_timer_timeout() -> void:
	var random_item: PackedScene = items.pick_random()
	var instance: Node = random_item.instantiate()
	add_child(instance)
	instance.position = markers.pick_random().position
