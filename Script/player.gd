extends CharacterBody2D

const JUMP_VELOCITY = -700.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if is_in_group("sampah_hit"):
		get_parent().game_over()

func _on_hit_box_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
