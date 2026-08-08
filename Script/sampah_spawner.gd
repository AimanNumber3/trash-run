extends Node2D

@export var bahaya: Array[PackedScene]
@export var poins: Array[PackedScene]
@export var bahaya_chance: float = 0.45
@export var poins_chance: float = 0.45
@export var spawn_distance: float = 370.0

@onready var markers: Array[Marker2D] = [$Marker2D, $Marker2D2]

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
	
	if roll < bahaya_chance and bahaya.size() > 0:
		spawn_scene = bahaya.pick_random()
	elif roll < bahaya_chance + poins_chance and poins.size() > 0:
		spawn_scene = poins.pick_random()
	else:
		return
	
	var instance: Node = spawn_scene.instantiate()
	add_child(instance)
	instance.position = markers.pick_random().position
