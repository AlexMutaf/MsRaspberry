extends Sprite2D

@export var rotation_speed: float = -20.0 # Speed

func _process(delta: float) -> void:	
	rotation_degrees += rotation_speed * delta
