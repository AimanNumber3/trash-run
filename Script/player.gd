extends CharacterBody2D

const JUMP_VELOCITY = -700.0
var is_invulnerable: bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	move_and_slide()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("sampah_hit") and not is_invulnerable:
		take_damage()

func take_damage() -> void:
	GameManager.lose_heart()
	is_invulnerable = true
	modulate.a = 0.5
	await get_tree().create_timer(1.0).timeout
	modulate.a = 1.0
	is_invulnerable = false
