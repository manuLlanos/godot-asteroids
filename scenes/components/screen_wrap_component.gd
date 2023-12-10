extends Node2D

# This node should be the child of the object you want to wrap around the screen
# And the size should be adjusted accordingly
@onready var parent = get_parent()
@onready var viewport_size: Vector2 = get_viewport_rect().size


func _ready():
	if ! parent:
		push_error("SCREEN WRAP COMPONENT IS NOT CHILD OF NODE")

func _physics_process(_delta):
	parent.global_position = parent.global_position.posmodv(viewport_size)
