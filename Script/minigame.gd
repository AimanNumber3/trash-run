extends Node2D

@onready var item_spawner: Node2D = $ItemSpawner
@onready var preview_slots: Array[Node2D] = [
	$MinigameHUD/TargetPreview/slot1,
	$MinigameHUD/TargetPreview/slot2,
	$MinigameHUD/TargetPreview/slot3,
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music("minigame")
	GameManager.minigame_bonus_score = 0
	$MinigameHUD.get_node("TargetLabel").text = GameManager.pending_trash_type
	_setup_target_preview(GameManager.pending_trash_type)
	$MinigameTimer.timeout.connect(_on_minigame_timer_timeout)
	$MinigameTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$MinigameHUD.get_node("TimeLabel").text = "WAKTU: " + str(int($MinigameTimer.time_left))
	$MinigameHUD.get_node("ScoreContainer/BonusLabel").text = "BONUS: " + str(GameManager.minigame_bonus_score)
	$MinigameHUD.get_node("ScoreContainer/ScoreLabel").text = "SKOR: " + str(GameManager.score + GameManager.minigame_bonus_score)

func _on_minigame_timer_timeout() -> void:
	end_minigame()

func end_minigame() -> void:
	GameManager.add_score(GameManager.minigame_bonus_score)
	GameManager.minigame_bonus_score = 0
	GameManager.returning_from_minigame = true
	TransitionManager.change_scene("res://Scenes/world.tscn")

func _setup_target_preview(category: String) -> void:
	var matching_scenes: Array = item_spawner.get_scenes_for_category(category)
	if matching_scenes.is_empty():
		push_warning("MinigameHUD: tidak ada item dengan kategori '%s' untuk preview." % category)
		return
	for slot in preview_slots:
		var picked: PackedScene = matching_scenes.pick_random()
		_fill_slot(slot, picked)

func _fill_slot(slot: Node2D, item_scene: PackedScene) -> void:
	_clear_slot(slot)
	var temp_instance: Node = item_scene.instantiate()
	var source_visual: Node2D = _find_visual_node(temp_instance)
	if source_visual == null:
		push_warning("MinigameHUD: tidak menemukan Sprite2D/AnimatedSprite2D di dalam scene sampah untuk preview.")
		temp_instance.queue_free()
		return
	var preview_visual: Node2D = source_visual.duplicate()
	preview_visual.position = Vector2.ZERO
	preview_visual.rotation = 0.0
	slot.add_child(preview_visual)
	temp_instance.queue_free()

func _clear_slot(slot: Node2D) -> void:
	for child in slot.get_children():
		child.queue_free()

func _find_visual_node(node: Node) -> Node2D:
	if node is Sprite2D or node is AnimatedSprite2D:
		return node
	for child in node.get_children():
		var found := _find_visual_node(child)
		if found:
			return found
	return null
