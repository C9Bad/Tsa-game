extends Area2D

@export var splash_scene: PackedScene = preload("res://Assets/Common/SplashEffect.tscn")
@export var respawn_sprite_scene: PackedScene = preload("res://Assets/Common/Revive Star.tscn")
@export var splash_default_width: float = 100.0

@export var predefined_spawn_positions: Array[Vector2] = [
	Vector2(1150, 530),
	Vector2(300, 300),
	Vector2(1250, 450)
]

@onready var character1: Node = get_node("/root/World/Character 1")
@onready var character2: Node = get_node("/root/World/Character 2")
@onready var audio_player: AudioStreamPlayer = $"../DeathSFX"
@onready var lose: AudioStreamPlayer = $"../Lose"

var lost: bool = false

var time_left: int = 30

func _on_game_timer_timeout():
	if not Globalvars or not is_inside_tree():
		return

	time_left -= 1

	if time_left <= 0 and (Globalvars.player1_dead or Globalvars.player2_dead):
		lost = true
		print(lost)

func fade_out_and_move(target: Node) -> void:
	if splash_scene:
		var splash = splash_scene.instantiate()
		get_tree().current_scene.add_child(splash)
		
		var target_width: float = 0.0
		var target_height: float = 0.0
		var base_position: Vector2 = target.global_position
		
		var collision_shape: CollisionShape2D = target.get_node_or_null("CollisionShape2D")
		if collision_shape and collision_shape.shape:
			if collision_shape.shape is RectangleShape2D:
				var rect_shape: RectangleShape2D = collision_shape.shape as RectangleShape2D
				target_width = rect_shape.extents.x * 2 * target.scale.x
				target_height = rect_shape.extents.y * 2 * target.scale.y
				base_position = target.global_position + collision_shape.position * target.scale
			else:
				splash.global_position = target.global_position
		else:
			splash.global_position = target.global_position
		
		if target_width > 0:
			var scale_factor = target_width / splash_default_width
			splash.scale = Vector2(scale_factor, scale_factor)
			splash.global_position = base_position + Vector2(0, target_height / 2)
		
		var tween = get_tree().create_tween()
		tween.tween_property(target, "position:y", target.position.y + target_width / 2, 0.3)
		tween.tween_property(target, "modulate:a", 0.0, 0.1)

func _on_body_entered(body: Node2D) -> void:
	if body == character1:
		if not Globalvars.player1_dead:
			audio_player.play()
			Globalvars.player1_dead = true
			fade_out_and_move(character1)
			character1.speed = character1.speed / 4

	elif body == character2:
		if not Globalvars.player2_dead:
			audio_player.play()
			Globalvars.player2_dead = true
			fade_out_and_move(character2)
			character2.speed = character2.speed / 4

	if Globalvars.player1_dead or Globalvars.player2_dead:
		await get_tree().create_timer(1.0).timeout
		if not lost:
			lose.play()
		lost = true
		Transition.zoom_to_scene("res://Stages/Game Stage/Stage 2/Level2.tscn")
