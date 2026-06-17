extends Sprite2D

@export var amplitude: float = 38.0
@export var speed: float = 2.4

var start_y: float
var time: float = 0.0

func _ready() -> void:
	start_y = position.y

func _process(delta: float) -> void:
	time += delta * speed
	position.y = start_y + sin(time) * amplitude
