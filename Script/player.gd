extends CharacterBody2D

const JUMP_VELOCITY = -700.0
const JUMP_MULTIPLIER = 0.8
const GRAVITY_MULTIPLIER = 2

var is_invulnerable: bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			velocity += get_gravity() * GRAVITY_MULTIPLIER * delta
		else:
			velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#handle how high the jump base on how long button is pressed
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= JUMP_MULTIPLIER
	move_and_slide()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("sampah_hit") and not is_invulnerable:
		take_damage()
	elif area.is_in_group("sampah_poin"):
		GameManager.add_score(10)
		area.queue_free()

func take_damage() -> void:
	GameManager.lose_heart()
	is_invulnerable = true
	modulate.a = 0.5
	await get_tree().create_timer(1.0).timeout
	modulate.a = 1.0
	is_invulnerable = false
