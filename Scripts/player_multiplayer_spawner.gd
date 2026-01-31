extends MultiplayerSpawner

signal player_spawned()
signal player_removed()

@export var playerScene : PackedScene
@onready var spawn_point : Area3D = $"../SpawnPoint"
@onready var game_controler = $".."

var players_spawned: int

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	players_spawned = 0
	spawn_function = spawn_player
	
	if multiplayer.is_server():
		handle_spawn_data(1) # 1 is always the host id
		# peer connected and disconnected alredy pass the multiplayer id to the calling function
		multiplayer.peer_connected.connect(handle_spawn_data)
		multiplayer.peer_disconnected.connect(remove_player)
		
# ---------------------------------------------------------------------------- #

func handle_spawn_data(id):
	
	if players_spawned < 2:
		var player_data = {"id": id}
		spawn.call_deferred(player_data)
		players_spawned += 1
		player_spawned.emit()
		return
			
	print('Não há vagas disponíveis para mais um jogador')

func spawn_player(data):
	
	var player = playerScene.instantiate()
	player.position = spawn_point.position
	player.name = str(data.id)
	player.set_collision_mask_value(2, false)
	player.set_multiplayer_authority(data.id)

	return player 
	
# ---------------------------------------------------------------------------- #

func remove_player(id):
	
	if get_node(spawn_path).has_node(str(id)):
		var player = get_node(spawn_path).get_node(str(id))
		player.queue_free()
	
	if multiplayer.is_server(): 
		players_spawned -= 1
		player_removed.emit()
		
# ---------------------------------------------------------------------------- #
