extends Label

@onready var score_controller: ScoreController = %ScoreController


func _ready() -> void:
	score_controller.score_update.connect(update_score_label)

func update_score_label(value : int):
	text = str(value)
