extends CanvasLayer

# should be a child of the main level
@onready var score_label: Label = %ScoreLabel
@onready var lives_label: Label = %LivesLabel
@onready var game_over = %GameOver
@onready var restart_button = $GameOver/RestartButton



func _ready():
	game_over.hide()
	Globals.connect("update_ui", update_ui)
	Globals.connect("game_over", _on_game_over)
	update_ui()

func update_ui():
	score_label.text = str(Globals.score)
	lives_label.text = str(Globals.lives)

func _on_game_over():
	await get_tree().create_timer(1).timeout
	game_over.show()
	restart_button.grab_focus()


func _on_restart_button_pressed():
	Globals.reset()
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
