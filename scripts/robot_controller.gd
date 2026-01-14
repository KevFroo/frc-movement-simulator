extends CharacterBody2D

@export var speed = 20
@export var rot_speed = 4.0
@export var push_strength := 300

const MAX_ACCELATION = 50
const FRICTION = 8

func _physics_process(delta):
	# handles movements
	
	# get direction from two different axis
	var direction := Input.get_vector("go_west", "go_east", "go_north", "go_south")
	if direction.x:
		# add movement to velocity and clamp the acceleration
		velocity.x += direction.x * speed * delta
		velocity.x = clamp(velocity.x, -MAX_ACCELATION, MAX_ACCELATION)
	else:
		# slow the movements down when not moving
		velocity.x = move_toward(velocity.x, 0, speed * delta * FRICTION)
	if direction.y:
		# add movement to velocity and clamp the acceleration
		velocity.y += direction.y * speed * delta
		velocity.y = clamp(velocity.y, -MAX_ACCELATION, MAX_ACCELATION)
	else:
		# slow the movements down when not moving
		velocity.y = move_toward(velocity.y, 0, speed * delta * FRICTION)
	
	# turn the node
	var turn_direction := Input.get_axis("turn_left", "turn_right")
	rotation += turn_direction * rot_speed * delta
	
	# checks for collision and bounce back node
	var collision := move_and_collide(velocity)
	if collision:
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_impulse(
				direction * push_strength
			)
		else:
			velocity = velocity.bounce(collision.get_normal()) * 0.5
		
	move_and_slide()
