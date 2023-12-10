extends Area2D

@export var speed: int = 100
## On death, creates two of this scene. (Drag a smaller asteroid here or leave it empty)
@export var divides_into_scene: PackedScene
## The score this asteroid is worth
@export var score: int = 250
var direction: Vector2 = Vector2.UP


func _ready():
	direction = direction.rotated(randf_range(0, 2*PI))
	rotation = randf_range(0, 2*PI)

func _physics_process(delta):
	position += speed * direction * delta

func hit():
	if divides_into_scene:
		for i in 2:
			var asteroid = divides_into_scene.instantiate()
			asteroid.global_position = global_position
			get_parent().call_deferred("add_child", asteroid)
	Globals.score += score
	queue_free()


# should only crash with characer bodies (player and ufos)
# the bullets and other asteroids are area2ds
func _on_body_entered(body):
	if "hit" in body:
		body.hit()

