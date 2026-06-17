extends Node2D

# Pressing the button 

	
func _on_tips_pressed() -> void:
	get_node("CanvasLayer/Control/tips_panel").visible = true

func _on_shop_pressed() -> void:
	get_node("CanvasLayer/Control/shop_panel").visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()
	
func _on_tips_close_pressed() -> void:
	get_node("CanvasLayer/Control/shop_panel").visible = false
	get_node("CanvasLayer/Control/tips_panel").visible = false
	get_node("CanvasLayer/Control/credits_panel").visible = false
	$"CanvasLayer/Control/Hover Button".play()
	
func _on_to_shop_pressed() -> void:
	get_node("CanvasLayer/Control/tips_panel").visible = false
	get_node("CanvasLayer/Control/shop_panel").visible = true
	get_node("CanvasLayer/Control/credits_panel").visible = false
	$"CanvasLayer/Control/Hover Button".play()
	
func _on_to_tips_pressed() -> void:
	get_node("CanvasLayer/Control/tips_panel").visible = true
	get_node("CanvasLayer/Control/shop_panel").visible = false
	get_node("CanvasLayer/Control/credits_panel").visible = false
	$"CanvasLayer/Control/Hover Button".play()
	
func _on_to_credits_pressed() -> void:
	get_node("CanvasLayer/Control/tips_panel").visible = false
	get_node("CanvasLayer/Control/shop_panel").visible = false
	get_node("CanvasLayer/Control/credits_panel").visible = true
	$"CanvasLayer/Control/Hover Button".play()

# Hovering over the button.
func _on_tips_mouse_entered() -> void:
	$"CanvasLayer/Control/Hover Button".play()

func _on_shop_mouse_entered() -> void:
	$"CanvasLayer/Control/Hover Button".play()

func _on_exit_mouse_entered() -> void:
	$"CanvasLayer/Control/Hover Button".play()

# Start button

@onready var flask = $CanvasLayer/Flask
@onready var start_button = $"CanvasLayer/Control/Invisible Start Button"

@export var speed: float = 5
@export var radius: float = 50
@export var return_speed: float = 8

var is_hovered: bool = false
var angle: float = 0
var center_pos: Vector2

func _ready() -> void:
	center_pos = flask.position

func _process(delta: float) -> void:
	var target_pos: Vector2
	if is_hovered:
		angle += speed * delta
		var offset = Vector2(cos(angle), sin(angle)) * radius
		target_pos = center_pos + offset
	else:
		target_pos = center_pos
		angle = lerp(angle, 0.00, return_speed * delta)
	flask.position = flask.position.lerp(target_pos, return_speed * delta)

func _on_invisible_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")

func _on_invisible_start_button_mouse_entered() -> void:
	$"CanvasLayer/Control/Hover Flask".play()
	is_hovered = true

func _on_invisible_start_button_mouse_exited() -> void:
	is_hovered = false
