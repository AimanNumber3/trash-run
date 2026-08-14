extends CanvasLayer

@onready var transition_rect: ColorRect = $TransitionRect
@onready var fact_label: Label = $FactLabel

const FACT_SCENES := [
	"res://Scenes/world.tscn",
	"res://Scenes/minigame.tscn",
]
const FACT_DISPLAY_DURATION := 2.5
const FACT_FADE_DURATION := 0.4

const FACTS := [
	"Sampah plastik butuh ratusan tahun untuk terurai di alam.",
	"Sampah organik bisa diolah menjadi kompos untuk menyuburkan tanah.",
	"Memilah sampah dari rumah membantu mengurangi timbunan sampah di TPA.",
	"Kertas dan kardus termasuk sampah anorganik yang bisa didaur ulang.",
	"Sisa makanan dan daun kering termasuk sampah organik.",
	"Baterai bekas termasuk sampah berbahaya dan harus dibuang secara khusus.",
	"Mendaur ulang satu ton kertas dapat menyelamatkan sekitar 17 pohon.",
	"Botol plastik bisa didaur ulang menjadi berbagai produk baru, seperti serat pakaian.",
	"Sampah anorganik umumnya berasal dari bahan sintetis seperti plastik, logam, dan kaca.",
	"Mengompos sampah organik dapat mengurangi emisi gas metana di TPA.",
]

var _is_transitioning: bool = false
var _fact_tween: Tween

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("[Transition] children saat _ready: ", get_children())
	if transition_rect == null:
		push_error("TransitionManager: node TransitionRect tidak ditemukan! Cek nama/path node.")
	else:
		transition_rect.material.set_shader_parameter("zoom", 0.0)
		transition_rect.hide()
	if fact_label == null:
		push_error("TransitionManager: node FactLabel tidak ditemukan! Cek nama/path node — harus sibling dari TransitionRect, langsung di bawah node ini.")
	else:
		fact_label.hide()

func change_scene(target_path: String) -> void:
	print("[Transition] change_scene ke: ", target_path, " | sedang transisi? ", _is_transitioning)
	if _is_transitioning:
		push_warning("TransitionManager: change_scene dipanggil saat transisi lain masih berjalan, diabaikan.")
		return
	_is_transitioning = true

	var show_fact := target_path in FACT_SCENES
	print("[Transition] show_fact = ", show_fact)

	if transition_rect:
		transition_rect.show()
		var tween_in := create_tween()
		tween_in.tween_method(_set_progress, 2.0, 0.0, 0.5)
		await tween_in.finished

	if show_fact and fact_label:
		print("[Transition] mulai fade-in fakta")
		await _show_fact()
		print("[Transition] selesai fade-out fakta")

	get_tree().change_scene_to_file(target_path)
	await get_tree().process_frame

	if transition_rect:
		var tween_out := create_tween()
		tween_out.tween_method(_set_progress, 0.0, 2.0, 0.5)
		await tween_out.finished
		transition_rect.hide()

	_is_transitioning = false
	print("[Transition] selesai total")

func _show_fact() -> void:
	if _fact_tween:
		_fact_tween.kill()

	fact_label.text = FACTS.pick_random()
	fact_label.modulate.a = 0.0
	fact_label.show()

	_fact_tween = create_tween()
	_fact_tween.tween_property(fact_label, "modulate:a", 1.0, FACT_FADE_DURATION)
	await _fact_tween.finished

	await get_tree().create_timer(FACT_DISPLAY_DURATION, true).timeout

	_fact_tween = create_tween()
	_fact_tween.tween_property(fact_label, "modulate:a", 0.0, FACT_FADE_DURATION)
	await _fact_tween.finished

	fact_label.hide()

func _set_progress(value: float) -> void:
	if transition_rect:
		transition_rect.material.set_shader_parameter("zoom", value)
