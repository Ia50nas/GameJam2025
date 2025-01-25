extends CharacterBody2D

const speed := 300
var original : Vector2
var touched := false


func _ready() -> void:
	original = self.global_position
	
	
func _process(delta: float) -> void:
	if touched == true:
		print("process")
		position += Vector2(0, 2.0) * speed * delta


func _on_area_2d_area_entered(area) -> void:
	print("platform")
	$CollapseTimer.start()


func _on_collapse_timer_timeout() -> void:
	print("timer")
	touched = true
	$RestoreTimer.start()


func _on_restore_timer_timeout() -> void:
	print("timer2")
	position = original
	touched = false
