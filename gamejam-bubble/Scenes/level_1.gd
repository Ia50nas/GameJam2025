extends Node2D

var playerScene=preload("res://bulle.tscn")
var spawnPosition=Vector2.ZERO
var currentPlayerNode=null
var Playerhealth=0
var Playerstamina=0
var dead=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnPosition=$Bulle.global_position
	register_Bulle($Bulle)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_UI()
func register_Bulle(player):
	currentPlayerNode=player
	currentPlayerNode.died.connect(on_player_died)
func create_player():
	var PlayerInstance=playerScene.instantiate()
	add_child(PlayerInstance)
	PlayerInstance.global_position=spawnPosition
	register_Bulle(PlayerInstance)
	dead=false
func on_player_died():
	dead=true
	currentPlayerNode.queue_free()
	var timer=get_tree().create_timer(1)
	await timer.timeout
	create_player()
func change_UI():
	if dead==false:
		if currentPlayerNode.health==3:
			$"LevelUI/Health Bar".play("3")
		elif currentPlayerNode.health==2:
			$"LevelUI/Health Bar".play("2")
		elif  currentPlayerNode.health==1:
			$"LevelUI/Health Bar".play("1")
		elif  currentPlayerNode.health==0:
			$"LevelUI/Health Bar".play("0")
		if  currentPlayerNode.bubble_mix==400:
			$"LevelUI/Soap Bar".play("100")
		elif  currentPlayerNode.bubble_mix>=300:
			$"LevelUI/Soap Bar".play("75")
		elif  currentPlayerNode.bubble_mix>=200:
			$"LevelUI/Soap Bar".play("50")
		elif  currentPlayerNode.bubble_mix>=100:
			$"LevelUI/Soap Bar".play("25")
		elif  currentPlayerNode.bubble_mix==0:
			$"LevelUI/Soap Bar".play("0")
	else:
		$"LevelUI/Health Bar".play("0")
		$"LevelUI/Soap Bar".play("0")
			
	
	
	
