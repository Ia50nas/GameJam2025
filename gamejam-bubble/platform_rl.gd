extends CharacterBody2D

@export var speed := 50
var max_width : float
var min_width : float
var direction := "right"

func _ready() -> void:
	max_width = global_position.x + 50
	min_width = global_position.x - 50
	print(max_width)
	print(min_width)
	

func _process(delta: float) -> void:
	print(position)
	if direction == "right" and position.x < max_width:
		position += Vector2(1.0, 0) * speed * delta
	elif direction == "left" and position.x > min_width:
		position += Vector2(-1.0, 0) * speed * delta
	elif position.x + 1 > max_width:
		direction = "left"
	elif position.x - 1 < min_width:
		direction = "right"
