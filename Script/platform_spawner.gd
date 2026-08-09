extends Node2D

@export var platforms: Array[PackedScene]
@export var checkpoint_platform: PackedScene
@export var spawn_distance: float = 500.0

@onready var marker: Marker2D = $Marker2D

var distance_storage: float = 0.0
var pending_checkpoint: bool = false

func _ready() -> void:
	GameManager.checkpoint_reached.connect(on_checkpoint_reached)

func on_checkpoint_reached() -> void:
	pending_checkpoint = true

func _process(delta: float) -> void:
	if not GameManager.game_running:
		return
	distance_storage += GameManager.speed * delta
	if distance_storage >= spawn_distance:
		distance_storage = 0.0
		try_spawn()

func try_spawn() -> void:
	var spawn_scene: PackedScene
	
	if pending_checkpoint and checkpoint_platform != null:
		spawn_scene = checkpoint_platform
		pending_checkpoint = false
	else:
		spawn_scene = platforms.pick_random()
	
	var instance: Node = spawn_scene.instantiate()
	add_child(instance)
	instance.position = marker.position
