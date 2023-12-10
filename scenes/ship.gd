extends CharacterBody2D
class_name Player

var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

@export var speed: int = 200
@export var rotation_speed: int = 30
@export var acceleration: int = 1
@export var shoot_delay: float = 0.2:
	set(value):
		shoot_delay = value
		%ShootCooldown.wait_time = shoot_delay
@export var warp_delay: float = 10
@export var invulnerable_time: float = 2
@export var death_particle: PackedScene
@export var whiten_material: ShaderMaterial

@onready var direction: Vector2 = Vector2.UP
@onready var animation_player = %AnimationPlayer
@onready var blinker = $BlinkerComponent
@onready var shield_sprite = %ShieldSprite
@onready var viewport_size: Vector2 = get_viewport_rect().size
@onready var teleport_in_scene: PackedScene = preload("res://scenes/effects/teleport_in_particles.tscn")
@onready var teleport_out_scene: PackedScene = preload("res://scenes/effects/teleport_in_particles.tscn")

var can_shoot: bool = true
var can_warp: bool = true
var vulnerable: bool = true
var has_shield: bool = false

signal shoot_laser(Area2D)
signal death

func _ready():
	shield_sprite.hide()
	make_invulnerable(invulnerable_time)
	%ShootCooldown.wait_time = shoot_delay
	%WarpCooldown.wait_time = warp_delay

func _physics_process(delta):
	var move_input: int = 0
	var rot_input: int = 0
	if Input.is_action_pressed("forward"):
		move_input += 1
	if Input.is_action_pressed("backward"):
		move_input -= 1
	if Input.is_action_pressed("rotate_left"):
		rot_input -= 1
	if Input.is_action_pressed("rotate_right"):
		rot_input += 1
	
	var rotation_target: float = rotation + rot_input * rotation_speed * delta
	rotation = lerp_angle(rotation, rotation_target, 0.1)
	var velocity_target = move_input * speed * direction
	velocity_target = velocity_target.rotated(rotation)
	velocity = lerp(velocity, velocity_target, acceleration * delta)
	
	if Input.is_action_just_pressed("fire") and can_shoot:
		shoot()
	if Input.is_action_just_pressed("warp") and can_warp:
		warp()
	
	if move_input != 0:
		animation_player.play("thrust")
		SoundManager.play_loop("RocketThrust")
	else:
		animation_player.play("RESET")
		SoundManager.stop("RocketThrust")
	
	Globals.player_pos = global_position
	move_and_slide()


func shoot():
	can_shoot = false
	SoundManager.play("Laser")
	
	var bullet = bullet_scene.instantiate()
	bullet.position = %LaserSpawnPosition.global_position
	bullet.rotation = rotation
	bullet.direction = (%LaserSpawnPosition.global_position - global_position).normalized()
	#$"../Projectiles".add_child(bullet)
	shoot_laser.emit(bullet)
	%ShootCooldown.start()


func _on_shoot_cooldown_timeout():
	can_shoot = true

func _on_warp_cooldown_timeout():
	can_warp = true

func hit():
	if not vulnerable:
		return
	
	if has_shield:
		has_shield = false
		shield_sprite.hide()
		make_invulnerable(invulnerable_time)
		return
	
	add_particles(death_particle)
	
	SoundManager.stop("RocketThrust")
	SoundManager.play("Explosion")
	Globals.lives -= 1
	death.emit()
	queue_free()


func make_invulnerable(time):
	vulnerable = false
	blinker.start_blinking(self, time)
	whiten_material.set_shader_parameter("whiten", true)
	await get_tree().create_timer(time).timeout
	whiten_material.set_shader_parameter("whiten", false)
	vulnerable = true

func warp():
	can_warp = false
	SoundManager.play("Teleport")
	add_particles(teleport_in_scene)
	position = Vector2(randf_range(0, viewport_size.x), randf_range(0, viewport_size.y))
	%WarpCooldown.start()
	add_particles(teleport_out_scene)

func add_particles(scene: PackedScene):
	var particles = scene.instantiate()
	particles.global_position = global_position
	particles.rotation = rotation
	get_tree().current_scene.call_deferred("add_child", particles)

func add_shield():
	has_shield = true
	shield_sprite.show()
