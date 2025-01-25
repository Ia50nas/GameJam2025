extends CharacterBody2D

@export var speed := 50
@export var max_height := 50
@export var min_height := 50
var direction := "down"


func _ready() -> void:
	max_height = global_position.y - max_height
	min_height = global_position.y + min_height


func _process(delta: float) -> void:
	if direction == "down" and position.y < min_height:
		position += Vector2(0, 1.0) * speed * delta
	elif direction == "up" and position.y > max_height:
		position += Vector2(0, -1.0) * speed * delta
	elif position.y + 2 > min_height:
		direction = "up"
	elif position.y - 2 < min_height:
		direction = "down"
