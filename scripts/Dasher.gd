extends CharacterBody2D

# Dasher properties
const SPEED = 60
const ACCELERATION = 500

var dash_speed : int = 300
var dash_range : int = 90
var dash_duration : float = 0.5
var dash_telegraph_duration : float = 0.2
var player
# Track dash state
var dashing : bool = false

func _ready():
	player = get_node("/root/Game/Character")



func _process(delta):
	if not dashing:
		move_towards_player(delta)
		move_and_slide()
	else:
		dash(delta)
		move_and_slide()
		
func move_towards_player(delta):
	var direction_to_player = (player.global_position - global_position).normalized()

	# Calculate the movement vector using the desired speed
	velocity = velocity.move_toward(direction_to_player * SPEED , delta* ACCELERATION)
	# Check if the player is within dash range
	var player_distance = global_position.distance_to(player.global_position)
	if player_distance < dash_range:
		attack_telegraph()

func attack_telegraph():
	# Implement any telegraph animation or behavior here
	# You may also play a sound or perform other actions to signal the upcoming dash
	await get_tree().create_timer(dash_telegraph_duration).timeout
	
	# Start dashing after the telegraph
	dashing = true

func dash(delta):
	# Calculate the dash direction based on the player's position
	var dash_direction = (player.global_position - global_position).normalized()

	# Apply the impulse
	velocity = velocity.move_toward(dash_direction * (SPEED + dash_speed) , delta* ACCELERATION)

	# Check if the player is within dash range
	var player_distance = global_position.distance_to(player.global_position)
	if player_distance > dash_range:
		dashing = false
	dashing = false
