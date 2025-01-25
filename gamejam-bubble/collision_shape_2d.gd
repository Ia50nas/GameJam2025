extends CollisionShape2D

var speed := 50
var max_height := -100
var min_height := 100
var direction := "down"


func _process(delta: float) -> void:
	print(self.global_position)
	if direction == "down" and self.global_position.y < min_height:
		position += Vector2(0, 1.0) * speed * delta
	elif direction == "up" and self.global_position.y > max_height:
		position += Vector2(0, -1.0) * speed * delta
	elif self.global_position.y + 2 > min_height:
		direction = "up"
	elif self.global_position.y - 2 < min_height:
		direction = "down"
