extends Sprite2D

@export var rotation_speed : float = -20.0 # Speed

# The following function runs automatically every frame of the game
func _process(delta: float) -> void:	
	# Multiplying by delta ensures it spins smoothly regardless of your PC's frame rate.
	rotation_degrees += rotation_speed * delta
