extends Path2D


@onready var spawn_point = %SpawnPoint
@onready var spawns = %Spawns
@onready var spawn_timer = %SpawnTimer

## The scene to spawn
@export var spawn_scene: PackedScene
## The time in seconds between each entity spawning
@export var spawn_wait_Time: float = 2
## The max ammount of spawns in any given time
@export var max_spawns: int = 5


func _ready():
	%SpawnTimer.wait_time = spawn_wait_Time
	%SpawnTimer.start()


func _on_spawn_timer_timeout():
	if spawns.get_children().size() < max_spawns:
		spawn_entity()

func spawn_entity():
	spawn_point.progress_ratio = randf()
	var spawn = spawn_scene.instantiate()
	spawn.global_position = spawn_point.global_position
	spawns.call_deferred("add_child", spawn)
