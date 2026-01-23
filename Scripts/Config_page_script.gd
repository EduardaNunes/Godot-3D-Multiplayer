extends Control

@onready var slider_principal: HSlider = $MarginContainer/VBoxContainer/Slider_Principal
@onready var slider_musica: HSlider = $MarginContainer/VBoxContainer/Slider_Musica
@onready var slider_sfx: HSlider = $MarginContainer/VBoxContainer/Slider_SFX
@onready var resolution_button: OptionButton = $MarginContainer/VBoxContainer/ResolutionButton

var resolution_dict : Dictionary[String, Vector2i] = {
	"1920x1080": Vector2i(1920, 1080)
}

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	slider_principal.value_changed.connect(update_vol_principal)
	slider_musica.value_changed.connect(update_vol_musica)
	slider_sfx.value_changed.connect(update_vol_sfx)
	resolution_button.item_selected.connect(update_resolution)

# ---------------------------------------------------------------------------- #

func update_vol_principal(value : float):
	var audio_id = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(audio_id, value)

# ---------------------------------------------------------------------------- #

func update_vol_musica(value : float):
	var audio_id = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(audio_id, value)

# ---------------------------------------------------------------------------- #

func update_vol_sfx(value : float):
	var audio_id = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(audio_id, value)

# ---------------------------------------------------------------------------- #

func update_resolution(idx : int):
	var new_res = resolution_dict[resolution_button.get_item_text(idx)]
	DisplayServer.window_set_size(new_res)
	get_tree().root.content_scale_size = new_res

# ---------------------------------------------------------------------------- #
