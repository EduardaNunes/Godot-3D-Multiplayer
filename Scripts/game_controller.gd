extends Node3D

var POINTS_TO_WIN = 4

func _ready() -> void:
	%ScoreController.connect('score_update', check_game_end)
	
func check_game_end(points : int) -> void:
	print('checa se ganhou')
	if points >= POINTS_TO_WIN:
		end_game()
		
func end_game():
	print('Jogadores Ganharam!')
