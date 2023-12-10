extends Marker2D

#should be child of main node/level

@onready var player = $Ship
@onready var start_pos: Vector2 = player.position

## The wait time for the player to respawn after death
@export var respawn_wait: float = 1

var player_scene: PackedScene = preload("res://scenes/ship.tscn")

signal create_laser(Area2D)

func _ready():
	player.shoot_laser.connect(func(bullet): create_laser.emit(bullet))
	player.connect("death", _on_ship_death)


func respawn():
	player = player_scene.instantiate()
	player.position = start_pos
	player.shoot_laser.connect(func(bullet): create_laser.emit(bullet))
	player.death.connect(_on_ship_death)
	await get_tree().create_timer(respawn_wait).timeout
	call_deferred("add_child", player)


func _on_ship_death():
	if !Globals.is_game_over:
		respawn()
