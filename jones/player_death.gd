extends CharacterBody2D
	
var spike_death = true

func _physics_process(delta: float) -> void:
	
	const gravity = 20
	var ground = true
	var air = false
	
	const stop_acceleration = 20
	const spike_death_acceleration = 10
	const go_acceleration = 10
	
	const force = 10

	
	#if spike_death == false:
	if $ground_cast_1.is_colliding() or $ground_cast_2.is_colliding():
		ground = true
		air = false
	else: 
		ground = false
		air = true

	
## Get Horizontal Vel ##


	if ground == true:
		velocity.x = lerpf(velocity.x,0,stop_acceleration * delta)
		
	## Get Vertical Vel ##
	
	
	
	if air == true:
		velocity.y += gravity * delta
		
	if ground == true:
		velocity.y = 0
	#else:
		#velocity.x = 0 
		#velocity.y = lerpf(velocity.y,0,spike_death_acceleration * delta)

	move_and_collide(velocity)	


func start(vel, pos, method):
	position = pos
	if method == 'spike':
		spike_death = true
		#velocity = vel
		#velocity = Vector2(-5,-5)
		rotation_degrees = 270
	
