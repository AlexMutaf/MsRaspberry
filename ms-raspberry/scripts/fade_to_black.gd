extends CanvasLayer

@onready var anim_player = $AnimPlayer;

func _ready() -> void:
	start_fade_sequence();
	return;

func start_fade_sequence() -> void:
	anim_player.play("fade_out");
	await anim_player.animation_finished;
	await get_tree().create_timer(1.75).timeout;
	get_tree().change_scene_to_file("res://scenes/questions.tscn");
	return;
