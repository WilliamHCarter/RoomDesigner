extends CharacterBody2D


# Base properties
var health : int = 100
var damage : int = 10

# Function to handle taking damage
func take_damage(amount: int):
	health -= amount
	if health <= 0:
		# Call a function for enemy death or handle it as per your game's logic
		queue_free()
