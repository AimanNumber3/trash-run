extends CharacterBody2D

const JUMP_VELOCITY = -1200.0
const JUMP_MULTIPLIER = 0.8

var is_invulnerable: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	velocity.y += GameManager.GRAVITY * delta
	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		AudioManager.play_sfx("jump")
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= JUMP_MULTIPLIER
	move_and_slide()
	update_animation()

func update_animation() -> void:
	var anim_target: String
	if GameManager.game_running:
		anim_target = "lari"
	else:
		anim_target = "idle"
	if animated_sprite_2d.animation != anim_target:
		animated_sprite_2d.play(anim_target)

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("sampah_hit") and not is_invulnerable:
		AudioManager.play_sfx("hit")
		take_damage()
	elif area.is_in_group("sampah_poin"):
		AudioManager.play_sfx("collect_point")
		GameManager.add_score(10)
		area.queue_free()
	elif area.is_in_group("checkpoin"):
		GameManager.trigger_checkpoint()

func take_damage() -> void:
	GameManager.lose_heart()
	is_invulnerable = true
	modulate.a = 0.5
	await get_tree().create_timer(1.0).timeout
	modulate.a = 1.0
	is_invulnerable = false
