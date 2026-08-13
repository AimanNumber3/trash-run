extends Control

@onready var back_button: Button = $VBoxContainer/BackButton
@onready var credit_lists: VBoxContainer = $VBoxContainer/ScrollContainer/CreditLists

const CREDITS := [
	{
		"kategori": "Musik",
		"nama": "Life is full of Joy",
		"author": "Clement Panchout",
		"url": "https://clementpanchout.itch.io/"
	},
	{
		"kategori": "Musik",
		"nama": "LJ_Tel_DnB",
		"author": "Clement Panchout",
		"url": "https://clementpanchout.itch.io/"
	},
	{
		"kategori": "SFX",
		"nama": "FreeVFX",
		"author": "Kronbits / @DavitMasia",
		"url": "https://kronbits.itch.io"
	},
	# tambahkan entry lain di sini
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	_populate_credits()

func _populate_credits() -> void:
	for child in credit_lists.get_children():
		child.queue_free()
	for entry in CREDITS:
		var label := RichTextLabel.new()
		label.bbcode_enabled = true
		label.fit_content = true
		label.scroll_active = false
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.custom_minimum_size = Vector2(0, 32)
		label.text = "[b]%s[/b] — %s\n[color=#8ab4f8][url=%s]%s[/url][/color]" % [
			entry["nama"], entry["author"], entry["url"], entry["url"]
		]
		credit_lists.add_child(label)
	var spacer := Control.new()
	spacer.custom_minimum_size.y = 12
	credit_lists.add_child(spacer)

func _on_back_button_pressed() -> void:
	AudioManager.play_sfx("button_return")
	TransitionManager.change_scene("res://Scenes/main_menu.tscn")
