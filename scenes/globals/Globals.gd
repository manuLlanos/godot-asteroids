extends Node

signal update_ui
signal game_over

var player_pos: Vector2 = Vector2.ZERO

var is_game_over: bool = false:
	set(value):
		is_game_over = value
		if is_game_over:
			game_over.emit()

@export var lives: int = 2:
	set(value):
		if value < 0:
			is_game_over = true
			return
		lives = value
		update_ui.emit()

var score: int = 0:
	set(value):
		if is_game_over:
			return
		score = value
		update_ui.emit()

func reset():
	is_game_over = false
	score = 0
	lives = 2
