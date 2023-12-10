extends Area2D

@export var speed: int = 800
@export var lifetime: float = 0.8
var direction: Vector2 = Vector2.ZERO

func _ready():
	%Timer.wait_time = lifetime
	%Timer.start()

func _physics_process(delta):
	position += speed * direction * delta


func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if "hit" in body:
		body.hit()
		queue_free()


func _on_area_entered(area):
	if "hit" in area:
		area.hit()
		queue_free()
