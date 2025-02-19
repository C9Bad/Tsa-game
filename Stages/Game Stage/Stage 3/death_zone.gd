extends Area2D

@onready var character1 = get_node("/root/World/Character 1")
@onready var character2 = get_node("/root/World/Character 2")
@onready var audio_player = $"../DeathSFX"
@onready var lose = $"../Lose"
var lost = false

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Character 1":
		if Globalvars.player1_dead == false:
			audio_player.play()
		Globalvars.player1_dead = true
		fade_out_and_spin(character1)
		character1.speed = 0
		character1.knockback_force = 0
		character1.knockback_duration = 0

	elif area.name == "Character 2":
		if Globalvars.player2_dead == false:
			audio_player.play()
		Globalvars.player2_dead = true
		fade_out_and_spin(character2)
		character2.speed = 0
		character2.knockback_force = 0
		character2.knockback_duration = 0

	# Check if both players are dead
	if Globalvars.player1_dead and Globalvars.player2_dead:
		await get_tree().create_timer(1.0).timeout
		if lost == false:
			lose.play()
		lost = true
		Transition.zoom_to_scene("res://Stages/Game Stage/Stage 3/Level3.tscn")



func fade_out_and_spin(target: Node) -> void:
	var tween = get_tree().create_tween()
	
	# Fade out effect
	tween.tween_property(target, "modulate:a", 0.0, 1.0)  # Fade out in 1 second

	# Spin effect (rotate by 360 degrees)
	tween.parallel().tween_property(target, "rotation_degrees", target.rotation_degrees + 360, 1.0)
