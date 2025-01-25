extends Camera2D

var targetPosition=Vector2.ZERO




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	acquire_target_position()
	global_position=lerp(targetPosition,global_position,pow(2,-15*delta))
	
func acquire_target_position():
	var players=get_tree().get_nodes_in_group("Bulle")
	if(players.size()>0):
		var player=players[0]
		if player.fall==false:
			targetPosition=player.global_position
