extends Control

@onready var config_page: Control = $"../ConfigPage"
@onready var pause_menu: CanvasLayer = $"../../.."
@onready var resume: Button = $MarginContainer/VBoxContainer/Resume
@onready var config: Button = $MarginContainer/VBoxContainer/Config
@onready var main_menu: Button = $MarginContainer/VBoxContainer/MainMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resume.pressed.connect(pause_menu.hide)
	config.pressed.connect(show_config)
	pause_menu.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		pause_menu.visible = !pause_menu.visible

func show_config():
	hide()
	config_page.show()

func return_to_main_menu():
	push_error("Method not implemented")
	pass
