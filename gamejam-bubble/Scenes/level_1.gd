extends Node2D

var playerScene=preload("res://bulle.tscn")
var spawnPosition=Vector2.ZERO
var currentPlayerNode=null
var Playerhealth=0
var dead=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnPosition=$Bulle.global_position
	register_Bulle($Bulle)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func register_Bulle(player):
	currentPlayerNode=player
	currentPlayerNode.died.connect(on_player_died)
func create_player():
	var PlayerInstance=playerScene.instantiate()
	add_child(PlayerInstance)
	PlayerInstance.global_position=spawnPosition
	Playerhealth=$Bulle.health
	register_Bulle(PlayerInstance)
	dead=false
func on_player_died():
	dead=true
	currentPlayerNode.queue_free()
	var timer=get_tree().create_timer(1)
	await timer.timeout
	create_player()
