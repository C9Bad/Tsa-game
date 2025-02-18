extends Node2D

var frogs1_scene = preload("res://Entities/Enemies/Frogs/Frogs1.tscn")
var frogs2_scene = preload("res://Entities/Enemies/Frogs/Frogs2.tscn")
var frogs3_scene = preload("res://Entities/Enemies/Frogs/Frogs3.tscn")

var frog_scenes: Array = []

@onready var enemy_timer = $"Enemy Spawn"  # Existing enemy spawn timer
@onready var game_timer = $"Game Timer"  # New game countdown timer
@onready var timer_label = $"Timer UI/TimerLabel"  # Label to show countdown
@onready var radial_progress = $"Timer UI/RadialProgress" #Progress bar
@onready var win_ui = $"Win UI"
@onready var start_ui = $"Start UI"
@onready var character1 = get_node("/root/World/Character 1")
@onready var character2 = get_node("/root/World/Character 2")
@onready var win = $Win
@onready var lose = $Lose

var spawn_enabled = false
var time_left = 30  # Start at 45 seconds

func _ready():
	Globalvars.player1_dead = false
	Globalvars.player2_dead = false
	update_timer_label()
	game_timer.wait_time = 1.0  # Game timer decreases every second
	frog_scenes = [frogs1_scene, frogs2_scene, frogs3_scene]

func _on_enemy_spawn_timeout() -> void:
	if not spawn_enabled:
		return
	
	var random_index = randi() % frog_scenes.size()
	var enemy_scene = frog_scenes[random_index]
	var enemy = enemy_scene.instantiate()
	$Enemies.add_child(enemy)
	
	var screen_size = get_viewport_rect().size
	enemy.position = Vector2(screen_size.x + 30, randf_range(0, screen_size.y))
	
	var total_frames = 5
	var anim_sprite = enemy.get_node("AnimatedSprite2D")
	if anim_sprite:
		anim_sprite.play("default")
		anim_sprite.flip_h = true
		anim_sprite.frame = randi() % total_frames

func _on_game_timer_timeout():
	if not spawn_enabled:
		return

	time_left -= 1
	update_timer_label()

	if time_left <= 0:
		stop_game()

func enable_spawning():
	spawn_enabled = true
	enemy_timer.start()
	game_timer.start()  # Start game countdown when enemies start spawning

func stop_game():
	spawn_enabled = false
	enemy_timer.stop()  # Stop enemy spawns
	game_timer.stop()  # Stop countdown

	for enemy in $Enemies.get_children():
		enemy.speed = 0

	for player in get_tree().get_nodes_in_group("player"):
		player.speed = 0

	var stars_awarded = 3

	await get_tree().create_timer(1.0).timeout
	if Globalvars.player1_dead and Globalvars.player2_dead:
		stars_awarded = 1
		lose.play()
	elif Globalvars.player1_dead or Globalvars.player2_dead:
		stars_awarded = 2
		lose.play()
	else:
		win.play()

	Globalvars.stage_data["stage_1"] = stars_awarded

	print("Game Over! Stars earned:", stars_awarded)
	
	Globalvars.player1_dead = false
	Globalvars.player2_dead = false
	
	if stars_awarded == 3:
		win_ui.visible = true
	else:
		Transition.zoom_to_scene("res://Stages/Game Stage/Stage 1/Level1.tscn")


func update_timer_label():
	timer_label.text = str(time_left)  # Update the on-screen timer
	radial_progress.progress = 30-time_left
