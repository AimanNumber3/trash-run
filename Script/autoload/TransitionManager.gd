extends CanvasLayer

@onready var transition_rect: ColorRect = $TransitionRect
@onready var tips_label: Label = $TipsLabel
@onready var tips_panel: VBoxContainer = $TipsPanel
@onready var texture_rect: TextureRect = $TipsPanel/TextureRect

const TIPS_SCENES := [
	"res://Scenes/world.tscn",
	"res://Scenes/minigame.tscn",
]
const TIPS_DURATION := 4
const TIPS_FADE := 0.4

const TIPS := [
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

var transitioning: bool = false
var tips_tween: Tween

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	transitioning = false
	if transition_rect == null:
		push_error("TransitionManager: node TransitionRect tidak ditemukan! Cek nama/path node.")
	else:
		transition_rect.material.set_shader_parameter("zoom", 0.0)
		transition_rect.hide()
	if tips_label == null:
		push_error("TransitionManager: node FactLabel tidak ditemukan! Cek nama/path node — harus sibling dari TransitionRect, langsung di bawah node ini.")
	else:
		tips_label.hide()
		tips_label.modulate.a = 0.0

func change_scene(target_path: String) -> void:
	if transitioning:
		push_warning("TransitionManager: change_scene dipanggil saat transisi lain masih berjalan, diabaikan.")
		return
	transitioning = true
	var show_tips := target_path in TIPS_SCENES
		
	if transition_rect:
		transition_rect.show()
		var tween_in := create_tween()
		tween_in.tween_method(_set_progress, 2.0, 0.0, 0.5)
		await tween_in.finished
	
	if show_tips and tips_label:
		await show_tips()
	
	get_tree().change_scene_to_file(target_path)
	await get_tree().process_frame
	
	if transition_rect:
		var tween_out := create_tween()
		tween_out.tween_method(_set_progress, 0.0, 2.0, 0.5)
		await tween_out.finished
		transition_rect.hide()
	
	transitioning = false

func show_tips() -> void:
	if tips_tween:
		tips_tween.kill()

	tips_label.text = TIPS.pick_random()
	tips_label.modulate.a = 0.0
	tips_label.show()

	tips_tween = create_tween()
	tips_tween.tween_property(tips_label, "modulate:a", 1.0, TIPS_FADE)
	await get_tree().create_timer(TIPS_FADE, true).timeout   # ganti dari await tips_tween.finished

	await get_tree().create_timer(TIPS_DURATION, true).timeout

	tips_tween = create_tween()
	tips_tween.tween_property(tips_label, "modulate:a", 0.0, TIPS_FADE)
	await get_tree().create_timer(TIPS_FADE, true).timeout   # ganti juga di sini

	tips_label.hide()

func _set_progress(value: float) -> void:
	if transition_rect:
		transition_rect.material.set_shader_parameter("zoom", value)
