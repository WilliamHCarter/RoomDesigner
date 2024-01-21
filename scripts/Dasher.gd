extends CharacterBody2D

# Core properties
const SPEED = 100
const ACCELERATION = 500
var player

#Dash Properties
var dash_speed : int = 250
var dash_range : int = 75
var dash_telegraph_duration : float = 0.4
var dash_duration : float = 0.8
var recovery_duration : float = 1.0



# Track attack state
var attack_timer : Timer = Timer.new()  # Use a Timer object for handling timers
var isDashing : bool = false

var attack_state : int = 0
enum AttackState { MOVE, TELEGRAPH, DASH, RECOVER }

# AnimatedSprite node
var animated_sprite : AnimatedSprite2D

func _ready():
	player = get_node("/root/Game/Character")
	animated_sprite = $AnimatedSprite2D
	add_child(attack_timer)  # Add the Timer node as a child

func _process(delta):
	match attack_state:
		AttackState.MOVE:
			move_towards_player(delta)
		AttackState.TELEGRAPH:
			attack_telegraph(delta)
		AttackState.DASH:
			dash(delta)
			#move_and_slide()
		AttackState.RECOVER:
			start_recovery(delta)
	move_and_slide()

func move_towards_player(delta):
	if animated_sprite.get_animation() != "Move":
		animated_sprite.play("Move")
	var direction_to_player = (player.global_position - global_position).normalized()

	# Calculate the movement vector using the desired speed
	velocity = velocity.move_toward(direction_to_player * SPEED, delta * ACCELERATION)
	# Check if the player is within dash range
	var player_distance = global_position.distance_to(player.global_position)
	if player_distance < dash_range && attack_state == AttackState.MOVE:
		progress_state()

func attack_telegraph(delta):
	animated_sprite.play("Telegraph")
	await get_tree().create_timer(dash_telegraph_duration).timeout
	if attack_state == AttackState.TELEGRAPH:
		progress_state()

func dash(delta):
	isDashing = true
	animated_sprite.play("Dash")
	# Calculate the dash direction based on the player's position
	var dash_direction = (player.global_position - global_position).normalized()

	# Apply the impulse
	velocity = velocity.move_toward(dash_direction * (SPEED + dash_speed), delta * ACCELERATION)
	await get_tree().create_timer(dash_duration).timeout
	if attack_state == AttackState.DASH:
		progress_state()

func start_recovery(delta):
	animated_sprite.play("Recover")
	isDashing = false
	velocity = Vector2.ZERO
	await get_tree().create_timer(recovery_duration).timeout
	if attack_state == AttackState.RECOVER:
		progress_state()


func dash_timer():
	await get_tree().create_timer(dash_duration).timeout
	progress_state()
	
	
func progress_state():
	# Timer has timed out, transition to the next attack state
	if attack_state == AttackState.MOVE:
		attack_state = AttackState.TELEGRAPH
	elif attack_state == AttackState.TELEGRAPH:
		attack_state = AttackState.DASH
	elif attack_state == AttackState.DASH:
		attack_state = AttackState.RECOVER
	elif attack_state == AttackState.RECOVER:
		attack_state = AttackState.MOVE
