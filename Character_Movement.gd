extends CharacterBody2D


const SPEED = 200
const ACCELERATION = 1750
const FRICTION = 3000


func player_movement(input, delta):
	if input: velocity = velocity.move_toward(input * SPEED , delta * ACCELERATION)
	else: velocity = velocity.move_toward(Vector2(0,0), delta * FRICTION)

func _physics_process(delta):
	var input = Input.get_vector("left","right","up","down")
	player_movement(input, delta)
	move_and_slide()
