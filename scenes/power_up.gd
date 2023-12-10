extends Area2D

var powerup_options = ["laser", "shield", "speed"]
var powerup_type = powerup_options.pick_random()

@export var sprites: Array[Texture2D]
@onready var sprite_2d = %Sprite2D
@onready var blinker = %BlinkerComponent

func _ready():
	match powerup_type:
		"laser":
			sprite_2d.texture = sprites[0]
		"shield":
			sprite_2d.texture = sprites[1]
		"speed":
			sprite_2d.texture = sprites[2]


func _on_fade_warning_timer_timeout():
	blinker.start_blinking(self, 3)


func _on_fade_timer_timeout():
	queue_free()

# only the player can be detected
func _on_body_entered(body):
	if ! (body is Player):
		return
	SoundManager.play("Powerup")
	match powerup_type:
		"laser":
			body.shoot_delay /= 1.5
		"shield":
			body.add_shield()
		"speed":
			body.speed *= 1.2
			body.rotation_speed *= 1.1
	queue_free()

