extends Control

@onready var tutorial_control = get_node("/root/World/Tutorial Control")

func _on_retry_pressed() -> void:
	tutorial_control.visible = true
	hide()
