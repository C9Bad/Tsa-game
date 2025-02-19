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

func _on_area_entered(area: Area2D) -> void:
	if area == character1:
		if not Globalvars.player1_dead:
			audio_player.play()
			Globalvars.player1_dead = true
			fade_out_and_spin(character1)
			character1.speed = character1.speed / 4
			character1.knockback_force = 0
			character1.knockback_duration = 0
			start_respawn_timer()

	elif area == character2:
		if not Globalvars.player2_dead:
			audio_player.play()
			Globalvars.player2_dead = true
			fade_out_and_spin(character2)
			character2.speed = character2.speed / 4
			character2.knockback_force = 0
			character2.knockback_duration = 0
			start_respawn_timer()

	if Globalvars.player1_dead and Globalvars.player2_dead:
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

func start_respawn_timer():
	var time_left = 5.0
	while time_left > 0:
		if lost or not is_inside_tree():
			return
		await get_tree().process_frame
		if lost or not is_inside_tree():
			return
		time_left -= get_process_delta_time()
	if lost or not is_inside_tree():
		return
	spawn_revive_sprite()

func spawn_revive_sprite():
	if respawn_sprite_scene:
		var respawn_sprite = respawn_sprite_scene.instantiate()
		call_deferred("_add_revive_sprite", respawn_sprite)

func _add_revive_sprite(respawn_sprite):
	get_tree().current_scene.add_child(respawn_sprite)

	var target_position = predefined_spawn_positions.pick_random()
	print(target_position)
	
	respawn_sprite.global_position = Vector2(target_position.x, -100)
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(respawn_sprite, "global_position", target_position, 1.5) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)
		
	if respawn_sprite.has_signal("collected"):
		respawn_sprite.connect("collected", Callable(self, "_on_respawn_sprite_collected"))

func _on_respawn_sprite_collected(character: Node):
	if character == character1 and Globalvars.player2_dead:
		Globalvars.player2_dead = false
		revive_character(character2, character1)
	elif character == character2 and Globalvars.player1_dead:
		Globalvars.player1_dead = false
		revive_character(character1, character2)

func revive_character(character: Node, ogCharacter: Node):
	character.modulate.a = 1.0
	character.knockback_force = 300
	character.knockback_duration = 0.2
	character.position = ogCharacter.position
	character.spawn_falling_animation()
