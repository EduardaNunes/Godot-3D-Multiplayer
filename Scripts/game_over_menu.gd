# ---------------------------------------------------------------------------- #

extends Control

@onready var audioPlayer : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var winner_label : Label = $Panel/Container/VBoxContainer/VBoxContainer2/Winner_Label
@onready var game_controller : Node3D = $"../.."

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	self.visible = false
	game_controller.connect('game_ended', show_gameover_menu.rpc)

# ---------------------------------------------------------------------------- #

func _on_exit_pressed() -> void:
	audioPlayer.play()
	await audioPlayer.finished
	
	multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file(GlobalMultiplayerNetwork.MENU_SCENE_PATH)

# ---------------------------------------------------------------------------- #

@rpc("authority", "call_local", "reliable")
func show_gameover_menu(winner) -> void:
	
	if winner == "Players": 
		winner_label.text = "Jogadores Ganharam!"
	elif winner == "Monster": 
		winner_label.text = "O Fantasminha Matou Todo Mundo :)"
	
	self.visible = true
	
# ---------------------------------------------------------------------------- #
