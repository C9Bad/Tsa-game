extends Area2D

@export var respawn_sprite_scene: PackedScene = preload("res://Assets/Common/Revive Star.tscn")

@export var predefined_spawn_positions: Array[Vector2] = [
	Vector2(680, 240),
	Vector2(600, 350),
	Vector2(700, 350)
]

@onready var character1 = get_node("/root/World/Character 1")
@onready var character2 = get_node("/root/World/Character 2")
@onready var audio_player = $"../DeathSFX"
@onready var lose = $"../Lose"

var lost: bool = false

var time_left: int = 30

func _on_game_timer_timeout():
	if not Globalvars or not is_inside_tree():
		return

	time_left -= 1

	if time_left <= 0 and (Globalvars.player1_dead or Globalvars.player2_dead):
		lost = true

func _on_body_entered(body: Node2D) -> void:
	if body == character1:
		if not Globalvars.player1_dead:
			audio_player.play()
			Globalvars.player1_dead = true
			fade_out_and_spin(character1)
			character1.speed = character1.speed / 4

	elif body == character2:
		if not Globalvars.player2_dead:
			audio_player.play()
			Globalvars.player2_dead = true
			fade_out_and_spin(character2)
			character2.speed = character2.speed / 4

	if Globalvars.player1_dead or Globalvars.player2_dead:
		await get_tree().create_timer(1.0).timeout
		if not lost:
			lose.play()
		lost = true
		Transition.zoom_to_scene("res://Stages/Game Stage/Stage 3/Level3.tscn")

func fade_out_and_spin(target: Node) -> void:
	var tween = get_tree().create_tween()
	
	# Fade out effect
	tween.tween_property(target, "modulate:a", 0.0, 1.0)  # Fade out in 1 second

	# Spin effect (rotate by 360 degrees)
	tween.parallel().tween_property(target, "rotation_degrees", target.rotation_degrees + 360, 1.0)
