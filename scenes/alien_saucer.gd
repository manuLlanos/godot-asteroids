extends CharacterBody2D

# Rotate the pivot to aim at the player

@onready var laser_pivot = $LaserPivot
@onready var laser_spawn = $LaserPivot/LaserSpawn
@onready var viewport_size: Vector2 = get_viewport_rect().size
@onready var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
@onready var powerup_scene: PackedScene = preload("res://scenes/power_up.tscn")

@export var speed: int = 150
@export var aim_error: int = 200
@export var score: int = 1000
@export var death_particle: PackedScene

signal shoot_laser(Area2D)

var can_shoot: bool = false
var can_move: bool = true
var move_target: Vector2
var aim_target: Vector2
var target_velocity: Vector2
var direction: Vector2 = Vector2.ZERO

func _ready():
	new_position_target()
	new_shooting_target()

func _physics_process(_delta):
	if can_shoot:
		shoot(aim_target)
	if can_move:
		target_velocity = speed * direction
	velocity = lerp(velocity, target_velocity, 0.1)
	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		if "hit" in collider:
			collider.hit()
			hit()

func new_position_target():
	move_target = Vector2(randf_range(0, viewport_size.x), randf_range(0, viewport_size.y))
	direction = (move_target - position).normalized()
	print(direction)


func new_shooting_target():
	aim_target = Globals.player_pos + Vector2(randf_range(-1, 1) * aim_error, randf_range(-1, 1) * aim_error)

func shoot(target: Vector2):
	can_shoot = false
	laser_pivot.look_at(target)
	var bullet = bullet_scene.instantiate()
	bullet.position = laser_spawn.global_position
	bullet.rotation = laser_pivot.rotation + PI/2
	bullet.direction = (laser_spawn.global_position - laser_pivot.global_position).normalized()
	
	# lets add the bullets to the parent for now
	get_parent().add_child(bullet)
	SoundManager.play("Laser")
	


func _on_shoot_cooldown_timeout():
	can_shoot = true
	new_shooting_target()


func _on_new_postition_cooldown_timeout():
	new_position_target()

func hit():
	var particle = death_particle.instantiate()
	particle.position = global_position
	particle.rotation = rotation
	get_tree().current_scene.add_child(particle)
	
	var powerup = powerup_scene.instantiate()
	powerup.position = global_position
	get_tree().current_scene.call_deferred("add_child", powerup)
	
	SoundManager.play("Explosion")
	Globals.score += score
	queue_free()
