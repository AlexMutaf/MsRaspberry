extends Node2D

@onready var new_sound = $Bubbling;

func _ready() -> void:
	var tween: Tween = create_tween();
	tween.set_parallel(true);
	tween.tween_property(new_sound, "volume_db", -40.0, 4.0);
	tween.set_parallel(false);
	tween.tween_callback(new_sound.stop);
	return;
