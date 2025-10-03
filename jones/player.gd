extends CharacterBody2D

var attack_count = 0
var last_played
const force = 20	
const gravity = 15
var ground = true
var air = false
var is_jumping = true
const stop_acceleration = 20
const go_acceleration = 10
var attacking = false
const max_speed = 3
var face_front= true
var can_jump = true
const jump_impulse = -6
var jump_count = 0
var prev_anim
var current_anim

func _ready() -> void:
	play_anim('idle')
	
func _physics_process(delta: float) -> void:
	

	
	if $ground_cast_1.is_colliding() or $ground_cast_2.is_colliding():
		if last_played == 'jump' and is_jumping == false:
			reset_anims()
			play_anim('idle')
		ground = true
		air = false
		attack_count = 0
		
		#animation_handler('jump_stop')
	else: 
		ground = false
		air = true
	
	## Get Horizontal Vel ##
	
	var x_input = get_x_input()
	
	
	if x_input != 0 and attacking == false:
		if x_input > 0:
			pass
			#face_front = true
			#$player_sprite.flip_h = false
		if x_input < 0:
			#$player_sprite.flip_h = true
			pass
			#face_front = false
		
		velocity.x = lerpf(velocity.x, x_input * max_speed, go_acceleration * delta)
	else:
		velocity.x = lerpf(velocity.x,0,stop_acceleration * delta)
		
	## Get Vertical Vel ##
	
	
	
	if air == true:
		if attacking == false:
			velocity.y += gravity * delta
		else:
			velocity.y = 0
		
	if ground == true:
		velocity.y = 0
	
	if Input.is_action_pressed("jump") and air == false and jump_count == 0 and attacking == false:
		jump(true)
		#animation_handler('jump_play')
	
	if Input.is_action_just_released("jump"):
		jump(false)
	
	
	#
	#if Input.is_action_just_pressed("attack"):
		#attack(get_x_input(),get_y_input(),air)
		
	move_and_collide(velocity)	

func get_x_input():
	var x_input = Input.get_axis("left","right")
	if $AnimationPlayer.is_playing():
		var node_path = 'animated_sprites/' + $AnimationPlayer.current_animation 
		var node = get_node(node_path)
		if x_input < 0:
			node.flip_h = true
			face_front = false
		if x_input > 0:
			face_front = true
			node.flip_h = false
		
		
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

#func attack(x,y,air):
	#
	#
	#$Timer.start()
	#var whip_dir = 0
	##for whip in $all_whips.get_children():
	##$whip.visible = true
	##$whip.monitorable = true
	##$whip.monitoring = true
	#if x == 0 and y == 0:
		#if  $player_sprite.flip_h == false:
			##$whip.rotation_degrees = 90
			#whip_dir = 0
		#else:
			##$whip.rotation_degrees = -90
			#whip_dir = 1
	#elif y != 0:
		#if y < 0 and air == true:
			#whip_dir = 2
		#if y > 0:
			#whip_dir = 3
		##if y > 0:
			##$whip.rotation_degrees = 0
			#
		##if y < 0 and air == true:
			##$whip.rotation_degrees = 180
			#
		#
	#else:
		#if x > 0:
			#whip_dir = 0
			#
		#else:
			#whip_dir = 1
			#
	#
	#$all_whips.get_child(whip_dir).visible = true
	#$all_whips.get_child(whip_dir).monitorable = true
	#$all_whips.get_child(whip_dir).monitoring = true
		#
		
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
	
func _unhandled_input(event: InputEvent) -> void:
	
	if attacking == false:
		if Input.is_action_just_pressed("attack"):
			if attack_count == 0:
				attack_count = 1
				attacking = true
				reset_anims()
				play_anim('side_attack')
		if Input.is_action_just_pressed("right"):
			face_front = true
			if ground == true :
				reset_anims()
				play_anim('run')
		if Input.is_action_just_pressed("left"):
			face_front = false
			if ground == true :
				reset_anims()
				play_anim('run')
		if Input.is_action_just_pressed("jump"):
			if ground == true:
				is_jumping = true
				reset_anims()
				play_anim('jump')
					
		if Input.is_action_just_released("left"):
			if ground == true:
				if get_x_input() == 0:
					reset_anims()
					play_anim('idle')
		if Input.is_action_just_released("right"):
			if ground == true:
				if get_x_input() == 0:
					reset_anims()
					play_anim('idle')
		
	
		
		
func reset_anims():
	pass

func play_anim(anim):
	$AnimationPlayer.stop()
	for sprite in $animated_sprites.get_children():
		sprite.visible = false 
	if get_x_input() ** get_x_input() == 0 and get_y_input() == 0 and ground == true and attacking == false and is_jumping == false:
		play_anim('idle')
	last_played = anim
	$AnimationPlayer.play(anim)
	var node_path = 'animated_sprites/' + anim
	var node = get_node(node_path)
	node.visible = true
	if face_front == true:
		node.flip_h = false
	else:
		node.flip_h = true
	#if $AnimationPlayer.current_animation == 'side_attack':
		#flip_side_attack(node.flip_h)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'jump':
		is_jumping = false
	if 'attack' in anim_name:
		attacking = false
		play_anim('idle')

#func flip_side_attack(flip):
	#if flip:
		#$all_whips/whip_right.rotation_degrees = -90
	#else:
		#$all_whips/whip_right.rotation_degrees = 90
