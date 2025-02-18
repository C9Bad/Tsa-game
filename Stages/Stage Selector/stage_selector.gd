extends Control

@onready var star1 = $Control/Star1
@onready var star2 = $Control/Star2
@onready var star3 = $Control/Star3
@onready var starAnimationPlayer = $AnimationPlayer

@onready var button1 = $Control/Button1
@onready var button2 = $Control/Button2
@onready var button3 = $Control/Button3

@onready var lock2 = $Control/Lock2
@onready var lock3 = $Control/Lock3

var stage_data

func _ready():
	stage_data = Globalvars.stage_data
	lock_unavailable_stages()

	starAnimationPlayer.play("rotation_animation")
	star1.play("default")
	star2.play("default")
	star3.play("default")

func lock_unavailable_stages():
	# Unlock Stage 2 if Stage 1 has 3 stars; otherwise, lock it.
	var stage2_unlocked = (stage_data.get("stage_1", 0) == 3)
	lock3.visible = not stage2_unlocked
	button2.disabled = not stage2_unlocked

	# Unlock Stage 3 if Stage 2 has 3 stars; otherwise, lock it.
	var stage3_unlocked = (stage_data.get("stage_2", 0) == 3)
	lock2.visible = not stage3_unlocked
	button3.disabled = not stage3_unlocked

func _on_button_1_pressed() -> void:
	Transition.zoom_to_scene("res://Stages/Game Stage/Stage 1/Level1.tscn")

func _on_button_2_pressed() -> void:
	if button2.disabled:
		return  # Prevent clicking when locked
	Transition.zoom_to_scene("res://Stages/Game Stage/Stage 2/Level2.tscn")

func _on_button_3_pressed() -> void:
	if button3.disabled:
		return  # Prevent clicking when locked
	Transition.zoom_to_scene("res://Stages/Game Stage/Stage 3/Level3.tscn")

func _on_stage_1_mouse_entered() -> void:
	star1.visible = true
	star1.frame = 0

func _on_stage_1_mouse_exited() -> void:
	star1.visible = false

func _on_stage_3_mouse_entered() -> void:
	if !button2.disabled:
		star2.visible = true
		star2.frame = 0

func _on_stage_3_mouse_exited() -> void:
	star2.visible = false

func _on_stage_2_mouse_entered() -> void:
	if !button3.disabled:
		star3.visible = true
		star3.frame = 0

func _on_stage_2_mouse_exited() -> void:
	star3.visible = false
