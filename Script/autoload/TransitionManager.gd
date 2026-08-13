extends CanvasLayer

@onready var transition_rect: ColorRect = $TransitionRect

func _ready() -> void:
	transition_rect.material.set_shader_parameter("zoom", 0.0)
	transition_rect.hide()

func change_scene(target_path: String) -> void:
	transition_rect.show()
	
	var tween_in := create_tween()
	tween_in.tween_method(_set_progress, 2.0, 0.0, 0.5)
	await tween_in.finished
	
	get_tree().change_scene_to_file(target_path)
	await get_tree().process_frame   
	
	var tween_out := create_tween()
	tween_out.tween_method(_set_progress, 0.0, 2.0, 0.5)
	await tween_out.finished
	
	transition_rect.hide()

func _set_progress(value: float) -> void:
	transition_rect.material.set_shader_parameter("zoom", value)
