extends Area2D

@export var splash_scene: PackedScene = preload("res://Assets/Common/SplashEffect.tscn")
@export var splash_default_width: float = 300.0

func kill_enemy(enemy: Node) -> void:
	if enemy.has_meta("killed") and enemy.get_meta("killed") == true:
		return
	enemy.set_meta("killed", true)
	enemy.speed = enemy.speed/4
	
	if splash_scene:
		var splash = splash_scene.instantiate()
		get_tree().current_scene.call_deferred("add_child", splash)

		var enemy_width: float = 0.0
		var enemy_height: float = 0.0
		var base_position: Vector2 = enemy.global_position

		var collision_shape: CollisionShape2D = enemy.get_node_or_null("Area2D/death shape")
		if collision_shape and collision_shape.shape:
			if collision_shape.shape is RectangleShape2D:
				var rect_shape: RectangleShape2D = collision_shape.shape as RectangleShape2D
				enemy_width = rect_shape.extents.x * 2 * enemy.scale.x
				enemy_height = rect_shape.extents.y * 2 * enemy.scale.y
				base_position = enemy.global_position + collision_shape.position * enemy.scale
			else:
				splash.global_position = enemy.global_position
				return
		else:
			splash.global_position = enemy.global_position
			return

		var scale_factor = enemy_width / splash_default_width
		splash.scale = Vector2(scale_factor, scale_factor)

		splash.global_position = base_position + Vector2(0, enemy_height / 2)
	
		enemy.stop_animation()
		var tween = get_tree().create_tween()
		tween.tween_property(enemy, "position:y", enemy.position.y + enemy_width / 2, 0.3)
		tween.tween_property(enemy, "modulate:a", 0.0, 0.1)

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		var enemy = area.get_parent()
		kill_enemy(enemy)
