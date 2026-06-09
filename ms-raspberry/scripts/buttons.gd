extends Node2D

func _on_tips_pressed() -> void:
	return
	get_tree().change_scene_to_file("");


func _on_shop_pressed() -> void:
	return
	get_tree().change_scene_to_file("");

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_tips_mouse_entered() -> void:
	$"Control/Hover Sound".play()

func _on_shop_mouse_entered() -> void:
	$"Control/Hover Sound".play()

func _on_exit_mouse_entered() -> void:
	$"Control/Hover Sound".play()
