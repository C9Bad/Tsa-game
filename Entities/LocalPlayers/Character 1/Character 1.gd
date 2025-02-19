extends Area2D

@export var speed: float = 200.0  # Movement speed
@export var knockback_force: float = 300.0 # How far the player gets pushed back
@export var knockback_duration: float = 0.2 # How long the knockback lasts

var velocity = Vector2.ZERO
var is_knocked_back = false
var knockback_timer = 0.0

@onready var animated_sprite = $AnimatedSprite2D

func _process(delta):
	if is_knocked_back:
		position.x -= knockback_force * delta
		knockback_timer -= delta
		if knockback_timer <= 0:
			is_knocked_back = false
		return

	velocity = Vector2.ZERO
	var old_position = position

	if Input.is_action_pressed("p1_up"):
		velocity.y = -1
	elif Input.is_action_pressed("p1_down"):
		velocity.y = 1

	if Input.is_action_pressed("p1_left"):
		velocity.x = -1
		animated_sprite.play("side") 
		animated_sprite.flip_h = true 
	elif Input.is_action_pressed("p1_right"):
		velocity.x = 1
		animated_sprite.play("side") 
		animated_sprite.flip_h = false  

	if velocity.x == 0:
		if velocity.y < 0:
			animated_sprite.play("back")
		elif velocity.y > 0:
			animated_sprite.play("front")
	if velocity == Vector2.ZERO:
		animated_sprite.stop()

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	
	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 60, screen_size.x - 60)
	position.y = clamp(position.y, 60, screen_size.y - 60)
	
	if get_overlapping_bodies().size() > 0 or get_overlapping_areas().size() > 0:
		position = old_position

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("entered")
	if area.is_in_group("enemies"):
		print("Hit by enemy!")
		is_knocked_back = true
		knockback_timer = knockback_duration

func spawn_falling_animation():
	var target_position = animated_sprite.position
	animated_sprite.global_position.y = -100  
	animated_sprite.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(animated_sprite, "position", target_position, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	await tween.finished
	
	speed = 200
