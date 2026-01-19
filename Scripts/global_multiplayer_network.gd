extends Node

signal connection_notification(sucess)

const MENU_SCENE_PATH : String = "res://Scenes/Menu.tscn"

var IP_ADRESS: String = "localhost"
const PORT: int = 42069
const MAX_CLIENTS = 3 # Default = 32

var peer: ENetMultiplayerPeer
var connection_timer: Timer

func _ready() -> void:
	multiplayer.server_disconnected.connect(on_server_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	
	setup_timer()

# ---------------------------------------------------------------------------- #

func start_server() -> bool:
	peer = ENetMultiplayerPeer.new()
	
	var error = peer.create_server(PORT, MAX_CLIENTS)
	if error != OK: return false
	
	multiplayer.multiplayer_peer = peer
	return true
	
# ---------------------------------------------------------------------------- #

func start_client(server_ip: String = "") -> void:
	
	if server_ip != "": IP_ADRESS = server_ip
	
	if IP_ADRESS != "localhost" and !IP_ADRESS.is_valid_ip_address():
		connection_notification.emit(false, 'Erro ao conectar: ip inserido não é válido')
		return
	
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADRESS, PORT)
	multiplayer.multiplayer_peer = peer
	
	connection_timer.start()

# ---------------------------------------------------------------------------- #

func on_server_disconnected() -> void:
	print("Disconectado do servidor. Voltando ao menu...")
	multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file(MENU_SCENE_PATH)
	
# ---------------------------------------------------------------------------- #

func _on_connected_ok():
	connection_timer.stop()
	
	connection_notification.emit(true, 'sucesso')

# ---------------------------------------------------------------------------- #

func _on_connected_fail():
	connection_timer.stop()
	_abort_connection()

# ---------------------------------------------------------------------------- #

func _abort_connection():
	multiplayer.multiplayer_peer = null
	connection_notification.emit(false, 'Erro ao conectar: tempo esgotado, servidor cheio ou offline')

# ---------------------------------------------------------------------------- #

func setup_timer() -> void:
	connection_timer = Timer.new()
	connection_timer.wait_time = 5.0
	connection_timer.one_shot = true
	connection_timer.timeout.connect(_abort_connection)
	add_child(connection_timer)
	
# ---------------------------------------------------------------------------- #
