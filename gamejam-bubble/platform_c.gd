extends CharacterBody2D

const speed := 400
var min_height := 1000
var original : Vector2
var touched := false


func _ready() -> void:
	original = self.global_position
	
	
func _process(delta: float) -> void:
	if self.global_position.y < min_height and touched == true:
		position += Vector2(0, 2.0) * speed * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	$CollapseTimer.start()


func _on_collapse_timer_timeout() -> void:
	touched = true
	$RestoreTimer.start()


func _on_restore_timer_timeout() -> void:
	position = original
	touched = false
