extends Node2D

@onready var ui = %UI

func _ready():
	SoundManager.play("Music")
	Globals.game_over.connect(func(): SoundManager.stop("Music"))

func _on_player_spawn_point_create_laser(bullet):
	$Projectiles.add_child(bullet)
