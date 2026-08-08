extends Node2D

@export var platforms: Array[PackedScene]
@export var spawn_distance: float = 500.0

@onready var marker: Marker2D = $Marker2D

var distance_storage: float = 0.0

func _process(delta: float) -> void:
	if not GameManager.game_running:
		return
	distance_storage += GameManager.speed * delta
	if distance_storage >= spawn_distance:
		distance_storage = 0.0
		try_spawn()

func try_spawn() -> void:
	var roll := randf()
	var spawn_scene: PackedScene = null
	
	spawn_scene = platforms.pick_random()
	
	var instance: Node = spawn_scene.instantiate()
	add_child(instance)
	instance.position = marker.position
