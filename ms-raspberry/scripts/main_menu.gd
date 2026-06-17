extends Node2D

# Main buttons (press & close)

func _on_tips_pressed() -> void:
	get_node("CanvasLayer/Control/tips_panel").visible = true;
	return;

func _on_shop_pressed() -> void:
	get_node("CanvasLayer/Control/shop_panel").visible = true;
	return;

func _on_exit_pressed() -> void:
	get_tree().quit();

func _on_panel_close_pressed() -> void:
	get_node("CanvasLayer/Control/shop_panel").visible = false;
	get_node("CanvasLayer/Control/tips_panel").visible = false;
	get_node("CanvasLayer/Control/credits_panel").visible = false;
	$"CanvasLayer/Control/Hover Button".play();
	return;


# Hovering over the main buttons

func _on_tips_mouse_entered() -> void:
	$"CanvasLayer/Control/Hover Button".play();
	return;

func _on_shop_mouse_entered() -> void:
	$"CanvasLayer/Control/Hover Button".play();
	return;

func _on_exit_mouse_entered() -> void:
	$"CanvasLayer/Control/Hover Button".play();
	return;


# Start button funcs

@onready var flask = $CanvasLayer/Flask;
@onready var start_button = $"CanvasLayer/Control/Invisible Start Button";

@export var speed: float = 5;
@export var radius: float = 50;
@export var return_speed: float = 8;

var is_hovered: bool = false;
var angle: float = 0;
var center_pos: Vector2;

func turning_flask(delta: float) -> void:
	var target_pos: Vector2;
	if (is_hovered == true):
		angle += speed * delta;
		var offset = Vector2(cos(angle), sin(angle)) * radius;
		target_pos = center_pos + offset;
	else:
		target_pos = center_pos;
		angle = lerp(angle, 0.00, return_speed * delta);
	flask.position = flask.position.lerp(target_pos, return_speed * delta);
	return;

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loading_screen.tscn");
	return;

func _on_start_button_mouse_entered() -> void:
	$"CanvasLayer/Control/Hover Flask".play();
	is_hovered = true;
	return;

func _on_start_button_mouse_exited() -> void:
	is_hovered = false;
	return;


# Panel Buttons

func _on_panel_shop_pressed() -> void:
	get_node("CanvasLayer/Control/tips_panel").visible = false;
	get_node("CanvasLayer/Control/shop_panel").visible = true;
	get_node("CanvasLayer/Control/credits_panel").visible = false;
	$"CanvasLayer/Control/Hover Button".play();
	return;

func _on_panel_tips_pressed() -> void:
	get_node("CanvasLayer/Control/tips_panel").visible = true;
	get_node("CanvasLayer/Control/shop_panel").visible = false;
	get_node("CanvasLayer/Control/credits_panel").visible = false;
	$"CanvasLayer/Control/Hover Button".play();
	return;

func _on_panel_credits_pressed() -> void:
	get_node("CanvasLayer/Control/tips_panel").visible = false;
	get_node("CanvasLayer/Control/shop_panel").visible = false;
	get_node("CanvasLayer/Control/credits_panel").visible = true;
	$"CanvasLayer/Control/Hover Button".play();
	return;


# Other buttons

@onready var siam_texture = preload("res://assets/sprites/main-menu/shop/Siam.png");

func _on_button_pressed() -> void:
	$CanvasLayer/MsRaspberry.texture = siam_texture;
	$"CanvasLayer/Control/Hover Button".play();
	return;

@onready var on_sign = preload("res://assets/sprites/main-menu/background/logo_sign.png");
@onready var off_sign = preload("res://assets/sprites/main-menu/background/logo_sign_off.png");

@onready var logo_sign = $CanvasLayer/Sign;

func _on_logo_off_pressed() -> void:
	if (logo_sign.texture == off_sign):
		logo_sign.texture = on_sign;
	else:
		logo_sign.texture = off_sign;
	$"CanvasLayer/Control/Hover Button".play();
	return;


# Default funcs

func _ready() -> void:
	center_pos = flask.position;
	return;

func _process(delta: float) -> void:
	turning_flask(delta);
	return;
