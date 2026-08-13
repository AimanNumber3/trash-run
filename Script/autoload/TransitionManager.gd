extends CanvasLayer

@onready var transition_rect: ColorRect = $TransitionRect
@onready var tips_label: Label = $TipsLabel

const TIPS_DURATION := 5
const TIPS_FADE := 0.4
const TIPS_SCENES := [
	"res://Scenes/world.tscn",
	"res://Scenes/minigame.tscn"
]

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

func _ready() -> void:
	transition_rect.material.set_shader_parameter("zoom", 0.0)
	transition_rect.hide()
	tips_label.hide()

func change_scene(target_path: String) -> void:
	var show_tips := target_path in TIPS_SCENES
	transition_rect.show()
	
	var tween_in := create_tween()
	tween_in.tween_method(_set_progress, 2.0, 0.0, 0.5)
	await tween_in.finished
	
	if show_tips:
		tips_label.text = TIPS.pick_random()
		tips_label.modulate.a = 0.0
		tips_label.show()
		
		var fade_in := create_tween()
		fade_in.tween_property(tips_label, "modulate:a", 1.0, TIPS_FADE)
		await fade_in.finished
		
		await get_tree().create_timer(TIPS_DURATION).timeout
		
		var fade_out := create_tween()
		fade_out.tween_property(tips_label, "modulate: a", 0.0, TIPS_FADE)
		await fade_out.finished
		tips_label.hide()
	
	get_tree().change_scene_to_file(target_path)
	await get_tree().process_frame   
	
	var tween_out := create_tween()
	tween_out.tween_method(_set_progress, 0.0, 2.0, 0.5)
	await tween_out.finished
	
	transition_rect.hide()

func _set_progress(value: float) -> void:
	transition_rect.material.set_shader_parameter("zoom", value)
