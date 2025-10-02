extends CharacterBody2D

const force = 20	
const gravity = 20
var ground = true
var air = false

const stop_acceleration = 20
const go_acceleration = 10

const max_speed = 5
#const jump_impulse = -5
var can_jump = true
const jump_impulse = -7
var jump_count = 0
func _physics_process(delta: float) -> void:
	

	
	if $ground_cast_1.is_colliding() or $ground_cast_2.is_colliding():
		ground = true
		air = false
	else: 
		ground = false
		air = true
	
	## Get Horizontal Vel ##
	
	var x_input = get_x_input()
	
	
	if x_input != 0:
		if x_input > 0:
			$player_sprite.flip_h = false
		if x_input < 0:
			$player_sprite.flip_h = true
		
		velocity.x = lerpf(velocity.x, x_input * max_speed, go_acceleration * delta)
	else:
		velocity.x = lerpf(velocity.x,0,stop_acceleration * delta)
		
	## Get Vertical Vel ##
	
	
	
	if air == true:
		velocity.y += gravity * delta
		
	if ground == true:
		velocity.y = 0
	
	if Input.is_action_pressed("jump") and air == false and jump_count == 0:
		jump(true)
	
	if Input.is_action_just_released("jump"):
		jump(false)
	
	
	if Input.is_action_just_pressed("attack"):
		attack(get_x_input(),get_y_input(),air)
		
	move_and_collide(velocity)	

func get_x_input():
	var x_input = Input.get_axis("left","right")
	return x_input

func get_y_input():
	var y_input = Input.get_axis("down","up")
	return y_input

func jump(can_jump):
	if can_jump == true:
		jump_count += 1
		velocity.y = jump_impulse
	if can_jump == false:
		if velocity.y < 0 and air == true:
			velocity.y = velocity.y/4
		jump_count = 0

func start():
	position = get_parent().get_child(0).position

func attack(x,y,air):
	
	$Timer.start()
	var whip_dir = 0
	#for whip in $all_whips.get_children():
	#$whip.visible = true
	#$whip.monitorable = true
	#$whip.monitoring = true
	if x == 0 and y == 0:
		if  $player_sprite.flip_h == false:
			#$whip.rotation_degrees = 90
			whip_dir = 0
		else:
			#$whip.rotation_degrees = -90
			whip_dir = 1
	elif y != 0:
		if y < 0 and air == true:
			whip_dir = 2
		if y > 0:
			whip_dir = 3
		#if y > 0:
			#$whip.rotation_degrees = 0
			
		#if y < 0 and air == true:
			#$whip.rotation_degrees = 180
			
		
	else:
		if x > 0:
			whip_dir = 0
			
		else:
			whip_dir = 1
			
	
	$all_whips.get_child(whip_dir).visible = true
	$all_whips.get_child(whip_dir).monitorable = true
	$all_whips.get_child(whip_dir).monitoring = true
		
		
func boost(dir):
	
	velocity = force/2 * dir
	
func _on_timer_timeout() -> void:
	$Timer.stop()
	for whip in $all_whips.get_children():
		whip.visible = false
		whip.monitorable = false
		whip.monitoring = false



func _on_whip_up_area_entered(area: Area2D) -> void:
	get_parent().remove_ghost(area.get_parent().get_parent())
	


func _on_whip_down_area_exited(area: Area2D) -> void:
	get_parent().remove_ghost(area.get_parent().get_parent())
	boost(Vector2(0,-1))


func _on_whip_right_area_entered(area: Area2D) -> void:
	get_parent().remove_ghost(area.get_parent().get_parent())
	boost(Vector2(-1,0))


func _on_whip_left_area_entered(area: Area2D) -> void:
	get_parent().remove_ghost(area.get_parent().get_parent())
	boost(Vector2(1,0))
