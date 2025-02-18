extends Control

func _on_exit_pressed() -> void:
	Transition.zoom_to_scene("res://Stages/Stage Selector/stage_selector.tscn")
