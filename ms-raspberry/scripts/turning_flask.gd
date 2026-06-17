extends Sprite2D

@export var rotation_speed: float = 350.0;
var direction: int = -1;
const stop_point: float = 20;

func _process(delta: float) -> void:
	if (rotation_speed < 10):
		rotation_degrees = 0;
		return;
	if (rotation_degrees >= stop_point):
		direction = -1;
	elif (rotation_degrees <= -stop_point):
		direction = 1;
	rotation_degrees += rotation_speed * direction * delta;
	rotation_speed -= 0.33;
	return;
	
