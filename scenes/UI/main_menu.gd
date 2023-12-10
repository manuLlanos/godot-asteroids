extends Node2D

@onready var start_button = %StartButton
@onready var exit_button = %ExitButton

var main_scene: PackedScene = preload("res://scenes/main.tscn")

func _ready():
	start_button.grab_focus()
	$Music.play()

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(main_scene)


func _on_exit_button_pressed():
	get_tree().quit()
