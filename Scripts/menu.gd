
# ---------------------------------------------------------------------------- #

extends Control
@export var gameScene : PackedScene
@export var tutorialScene : PackedScene
@export var CreditsScene : PackedScene
@export var menuButtons : Array[Button]

@onready var errorPanel : Panel = $Error
@onready var errorLabel : Label = $Error/Container/VBoxContainer/VBoxContainer2/Subtitle
@onready var audioPlayer : AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var inputIPPanel : Panel = $Input_IP
@onready var inputIP : LineEdit = $Input_IP/Container/VBoxContainer/LineEdit

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	toggle_buttons('enable')
	errorPanel.visible = false
	inputIPPanel.visible = false
	
	GlobalMultiplayerNetwork.connection_notification.connect(connect_client)

# ---------------------------------------------------------------------------- #

func _on_host_pressed() -> void:
	toggle_buttons('disable')
	audioPlayer.play()
	await audioPlayer.finished
	
	var sucess = GlobalMultiplayerNetwork.start_server()
	
	if sucess:
		get_tree().change_scene_to_packed(gameScene)
	else:
		errorLabel.text = 'O servidor já foi criado por outro host'
		toggle_error_panel()

# ---------------------------------------------------------------------------- #

func _on_client_pressed() -> void:
	audioPlayer.play()
	await audioPlayer.finished
	toggle_buttons('disable')
	toggle_input_ip_panel()
	
func _on_input_ip_ok_pressed() -> void:
	audioPlayer.play()
	await audioPlayer.finished
	
	GlobalMultiplayerNetwork.start_client(inputIP.text)
	toggle_input_ip_panel()
	
func connect_client(sucess : bool, message : String) -> void:
	if sucess: get_tree().change_scene_to_packed(gameScene)
	else:
		errorLabel.text = message
		toggle_error_panel()

# ---------------------------------------------------------------------------- #

func _on_tutorial_pressed() -> void:
	audioPlayer.play()
	await audioPlayer.finished
	toggle_buttons('disable')
	
	get_tree().change_scene_to_packed(tutorialScene)

# ---------------------------------------------------------------------------- #

func _on_credits_pressed() -> void:
	audioPlayer.play()
	await audioPlayer.finished
	toggle_buttons('disable')
	
	get_tree().change_scene_to_packed(CreditsScene)

# ---------------------------------------------------------------------------- #

func _on_exit_pressed() -> void:
	audioPlayer.play()
	await audioPlayer.finished
	toggle_buttons('disable')
	
	get_tree().quit()
	
# ---------------------------------------------------------------------------- #

func toggle_buttons(operation) -> void:
	
	if operation == 'disable' :
		operation = true
	elif operation == 'enable':
		operation = false
	else:
		print('operação inválida. Esperado: disable ou enable. Recebido: ', operation)
		return
		
	for button in menuButtons:
		button.disabled = operation

# ---------------------------------------------------------------------------- #

func toggle_error_panel() -> void:
	errorPanel.visible = !errorPanel.is_visible_in_tree()
	
	if(!errorPanel.is_visible_in_tree()): toggle_buttons('enable')
	else: toggle_buttons('disable')
	
func toggle_input_ip_panel() -> void:
	inputIPPanel.visible = !inputIPPanel.is_visible_in_tree()

# ---------------------------------------------------------------------------- #

func _on_error_ok_pressed() -> void:
	audioPlayer.play()
	await audioPlayer.finished
	
	errorLabel.text = 'Um erro aconteceu'
	toggle_error_panel()

# ---------------------------------------------------------------------------- #
