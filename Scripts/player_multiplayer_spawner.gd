extends MultiplayerSpawner

@export var playerScene : PackedScene
#@onready var game_controller : Node2D = $".."

var spawned_players : Array[bool] = [false, false, false, false]
var colors = ['green', 'blue', 'yellow', 'red']

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	
	spawn_function = spawn_player
	
	if multiplayer.is_server():
		handle_spawn_data(1) # 1 is always the host id
		# peer connected and disconnected alredy pass the multiplayer id to the calling function
		multiplayer.peer_connected.connect(handle_spawn_data)
		multiplayer.peer_disconnected.connect(remove_player)
		
# ---------------------------------------------------------------------------- #

func handle_spawn_data(id):
	
	for i in spawned_players.size():
		if not spawned_players[i]:
			var player_data = {"id": id, "color": colors[i]}
			spawn.call_deferred(player_data)
			spawned_players[i] = true
			return
			
	print('Não há vagas disponíveis para mais um jogador')

func spawn_player(data):
	
	var player = playerScene.instantiate()
	player.color = data.color
	#player.position = $"../Spawner".position
	player.name = str(data.id)
	player.set_multiplayer_authority(data.id)
	
	#if multiplayer.is_server():
		#game_controller.register_player.call_deferred(player)
	
	# When we return the object the spawn_function adds it to the node parent (spawn path)
	return player 
	
# ---------------------------------------------------------------------------- #

func remove_player(id):
	
	var player_color = '';
	
	if get_node(spawn_path).has_node(str(id)):
		var player = get_node(spawn_path).get_node(str(id))
		player_color = player.color
		player.queue_free()
	
	if multiplayer.is_server(): 
		spawned_players[colors.find(player_color)] = false
		#game_controller.unregister_player(player_color)
		
# ---------------------------------------------------------------------------- #
