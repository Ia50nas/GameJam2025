extends Area2D
func _on_laser_timer_timeout() -> void:
	visible = !visible
	$CollisionShape2D.disabled = !visible
