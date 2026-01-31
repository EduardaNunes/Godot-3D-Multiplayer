extends Node3D

@export var players_alive : int

var POINTS_TO_WIN = 4

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	%ScoreController.connect('score_update', check_game_end)
	$Monster.connect('player_kill', on_player_dead)
	$PlayerMultiplayerSpawner.connect('player_spawned', increase_players_alive)
	$PlayerMultiplayerSpawner.connect('player_removed', decrease_players_alive)
	
	if multiplayer.is_server():
		await get_tree().process_frame
		players_alive = $PlayerMultiplayerSpawner.players_spawned
		print(players_alive)
	
# ---------------------------------------------------------------------------- #

func check_game_end(points : int) -> void:
	if not multiplayer.is_server(): return
	
	if points >= POINTS_TO_WIN:
		end_game("Players")

# ---------------------------------------------------------------------------- #
	
func end_game(winner : String):
	if winner == "Players": print('Jogadores Ganharam!')
	elif winner == "Monster": print('Monstro Ganhou!')

# ---------------------------------------------------------------------------- #

func increase_players_alive() -> void:
	if not multiplayer.is_server(): return
	
	players_alive += 1
	print(players_alive)
	
# ---------------------------------------------------------------------------- #

func decrease_players_alive() -> void:
	if not multiplayer.is_server(): return
	
	players_alive -= 1
	print(players_alive)
	if players_alive <= 0: end_game("Monster")
	
# ---------------------------------------------------------------------------- #

func on_player_dead(player : CharacterBody3D) -> void:
	if not multiplayer.is_server(): return
	
	player.set_dead_state.rpc()
	decrease_players_alive()
