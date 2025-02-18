extends Control

@onready var next_button = $Next
@onready var video_player = $"Stage Tutorial"
@onready var world = get_node("/root/World")
@onready var tutorial_control = get_node("/root/World/Tutorial Control")
@onready var character1 = get_node("/root/World/Character 1")
@onready var character2 = get_node("/root/World/Character 2")

func _on_color_picker_button_color_changed(color):
	video_player.material.set("shader_parameter/chroma_key_color", color)

func _on_h_slider_value_changed(value):
	video_player.material.set("shader_parameter/threshold", value)

func _on_h_slider_2_value_changed(value):
	video_player.material.set("shader_parameter/smoothness", value)

func _on_video_stream_player_finished():
	video_player.play() 

func enable_movement():
	character1.speed = 200
	character2.speed = 200

func _on_next_button_pressed() -> void:
	world.enable_spawning() 
	enable_movement()
	next_button.hide()
	tutorial_control.hide()
