extends CharacterBody2D
var states=["normal","floating","homing","hurt"]
var current_state=states[0]
var gravity = 800
var maxHorizontalSpeed = 140
var horizontalAcceleration = 1000
var jumpSpeed = 300
var JumpTerminationMultiplier = 4
var SPEED = 250.0
var health = 3
var bubble_mix = 400
var max_bubble_mix = 400
var hasDoubeJump = false
#var floating_in_bubble = false
var float_up_speed = 500# Dash
var dash_speed = 400  # Dash speed
var dash_duration = 0.2  # Duration of the dash in seconds
var dash_cooldown = 0.5  # Time before the player can dash again
var is_dashing = false
var dash_timer = 0.0
var dash_direction = 0
var can_dash = true
var is_homing_active=false
var homing_target: Node2D=null
var homing_speed=400
var homing_detection_radius=200
var homing_lock_duration=1
var homing_timer=0.0
var homing_cooldown = 0.3
var can_homing_attack=true

var small_projectile_scene : PackedScene
var large_projectile_scene : PackedScene
var projectile_speed = 200
var hold_time = 1.0  # How long to hold for the large projectile
var hold_timer = 0.0
var is_holding = false

var isDying=false
var fall=false
signal died

func _ready():
	# Load your projectile scenes (set in the editor or loaded dynamically)
	small_projectile_scene = preload("res://bubble.tscn")
	large_projectile_scene = preload("res://big_bubble.tscn")
	$Void_Checker.connect("area_entered",_on_void_checker_area_entered)


func _process(delta: float):
	if current_state==states[1]:
		velocity = Vector2.ZERO
		velocity.y = float_up_speed
		if Input.is_action_just_pressed("jump"):
			print("pop")
	elif is_homing_active and homing_target:
		perform_homing_attack(delta)
		
	elif !is_homing_active:
		if is_dashing:
			dash_timer -= delta
			if dash_timer <= 0:
				stop_dash()
		else:
			if Input.is_action_pressed("create_bubble"):
				if not is_holding:
					is_holding = true
					hold_timer = 0.0 
				hold_timer+=delta
				if hold_timer>=hold_time:
					shoot_big_bubble()
				else:
					if is_holding:
						shoot_smol_bubble()
					is_holding=false
					hold_timer=0.0
					
			handle_movement(delta)
			handle_dash_input()

		var wasOnFloor = is_on_floor()
		if is_on_floor():
			hasDoubeJump = true

		move_and_slide()

		if wasOnFloor and !is_on_floor():
			$CoyoteTimer.start()

func handle_movement(delta: float):
	var moveVector = get_movement_vector()
	velocity.x += moveVector.x * horizontalAcceleration * delta
	if moveVector.x == 0:
		velocity.x = lerp(0, int(velocity.x), pow(2, -20 * delta))
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	if moveVector.y < 0 and (is_on_floor() or !$CoyoteTimer.is_stopped() or hasDoubeJump):
		velocity.y = moveVector.y * jumpSpeed
		if !is_on_floor() and $CoyoteTimer.is_stopped():
			hasDoubeJump = false
		$CoyoteTimer.stop()
	
	if velocity.y < 0 and !Input.is_action_pressed("jump"):
		velocity.y += gravity * JumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("homing_attack")and can_homing_attack:
		if !is_on_floor():
			homing_target=find_closest_target()
			if homing_target:
				current_state=states[2]
				is_homing_active=true
				homing_timer=homing_lock_duration

func handle_dash_input():
	if Input.is_action_just_pressed("Dash") and can_dash and not is_dashing:
		start_dash()

func start_dash():
	is_dashing = true
	can_dash = false
	dash_timer = dash_duration
	dash_direction = 1 if Input.get_action_strength("move_right") > 0 else -1
	velocity.x = dash_direction * dash_speed

func stop_dash():
	is_dashing = false
	velocity.x = 0
	# Wait for the cooldown timer to complete
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return moveVector
func find_closest_target():
	var closest_target = null
	var closest_distance = homing_detection_radius
	for body in get_tree().get_nodes_in_group("targets"): # Ensure your targets are in a "targets" group
		var distance = position.distance_to(body.global_position)
		if distance < closest_distance:
			print("homing")
			closest_target = body
			closest_distance = distance
	return closest_target


	
	

func perform_homing_attack(delta):
	while is_homing_active:
		if homing_target and homing_timer>0 and !is_on_wall():
			homing_timer-=delta
			var direction=(homing_target.global_position-position).normalized()
			velocity=direction*homing_speed
			move_and_slide()
			if position.distance_to(homing_target.global_position)<20:
				var jumper=1100
				if homing_target.is_in_group("smol"):
					jumper=700
				homing_target.queue_free()
				is_homing_active=false
				homing_target=null
				velocity.x=0
				velocity.y=-jumper
				can_homing_attack=false
				$Homing_cooldown.start(homing_cooldown)
				current_state=states[0]
		else:
			is_homing_active=false
			homing_target=null
			current_state=states[0]
	


func _on_homing_cooldown_timeout() -> void:
	can_homing_attack=true

func shoot_smol_bubble():
	var bubble=small_projectile_scene.instantiate()
	get_parent().add_child(bubble)
	bubble.position=position
	bubble.velocity=Vector2(projectile_speed,0)
	
func shoot_big_bubble():
	var bubble=large_projectile_scene.instantiate()
	get_parent().add_child(bubble)
	bubble.position=position
	bubble.velocity=Vector2(projectile_speed*1.5,0)

func kill():
	if isDying:
		return
	emit_signal("died")

	


func _on_void_checker_area_entered(area: Area2D) -> void:
	fall=true
	var timer=get_tree().create_timer(0.5)
	await timer.timeout
	emit_signal("died")
