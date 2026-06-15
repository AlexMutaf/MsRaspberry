extends CanvasLayer

@onready var anim_player = $AnimPlayer

func _ready():
	start_fade_sequence()

func start_fade_sequence():
	anim_player.play("fade_out")
	await anim_player.animation_finished
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/questions.tscn")
