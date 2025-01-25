extends CharacterBody2D

class_name Bubble

signal area_entered

const IMPULS_POWER = 20.0

var impuls = Vector2(0,0)
var areas = []
var destroyIt = false
var allowCollision = true

func Allow_collision(value: bool) -> void:
	allowCollision = value
	

func Set_impuls(value: Vector2) -> void:
	impuls = value;

func _physics_process(delta: float) -> void:
	if allowCollision:
		_impuls()
		
	velocity = impuls * delta
	impuls -= impuls * delta * 0.1

	move_and_slide()
	if destroyIt:
		queue_free()
	
func selfDestroy() -> void:
	destroyIt = true
	
func _impuls() -> void:
	for area: Area2D in areas:
		impuls += (global_position - area.global_position) * IMPULS_POWER

func _on_area_2d_area_entered(area: Area2D) -> void:
	areas.append(area)
	#impuls += Vector2(330, 300)

func _on_area_2d_area_exited(area: Area2D) -> void:
	areas.erase(area)
