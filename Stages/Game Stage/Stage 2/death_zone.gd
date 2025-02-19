extends Area2D

@export var splash_scene: PackedScene = preload("res://Assets/Common/SplashEffect.tscn")
@export var splash_default_width: float = 100.0

@onready var character1: Node = get_node("/root/World/Character 1")
@onready var character2: Node = get_node("/root/World/Character 2")
@onready var audio_player: AudioStreamPlayer = $"../DeathSFX"
@onready var lose: AudioStreamPlayer = $"../Lose"
var lost: bool = false

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Character 1":
		if not Globalvars.player1_dead:
			audio_player.play()
			Globalvars.player1_dead = true
			fade_out_and_move(character1)
			character1.speed = character1.speed / 4
			character1.knockback_force = 0
			character1.knockback_duration = 0

	elif area.name == "Character 2":
		if not Globalvars.player2_dead:
			audio_player.play()
			Globalvars.player2_dead = true
			fade_out_and_move(character2)
			character2.speed = character2.speed / 4
			character2.knockback_force = 0
			character2.knockback_duration = 0

	if Globalvars.player1_dead and Globalvars.player2_dead:
		await get_tree().create_timer(1.0).timeout
		if not lost:
			lose.play()
		lost = true
		Transition.zoom_to_scene("res://Stages/Game Stage/Stage 2/Level2.tscn")

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
	
		# Fade out the target and move it down.
		var tween = get_tree().create_tween()
		tween.tween_property(target, "position:y", target.position.y + target_width / 2, 0.3)
		tween.tween_property(target, "modulate:a", 0.0, 0.1)
