extends Area2D

@export var speed: float = 200.0  # Movement speed
@export var knockback_force: float = 300.0  # How far the player gets pushed back
@export var knockback_duration: float = 0.2  # How long the knockback lasts

var velocity = Vector2.ZERO
var is_knocked_back = false
var knockback_timer = 0.0
var is_dead = false

@onready var animated_sprite = $AnimatedSprite2D 

func _process(delta):
	if is_dead:
		return

	if is_knocked_back:
		position.x -= knockback_force * delta
		knockback_timer -= delta
		if knockback_timer <= 0:
			is_knocked_back = false
		return

	velocity = Vector2.ZERO

	# Movement input for Player 2
	if Input.is_action_pressed("p2_up"):
		velocity.y = -speed
	elif Input.is_action_pressed("p2_down"):
		velocity.y = speed

	if Input.is_action_pressed("p2_left"):
		velocity.x = -speed
		animated_sprite.play("side")
		animated_sprite.flip_h = true
	elif Input.is_action_pressed("p2_right"):
		velocity.x = speed
		animated_sprite.play("side")
		animated_sprite.flip_h = false 


	if velocity.x == 0:
		if velocity.y < 0:
			animated_sprite.play("back")
		elif velocity.y > 0:
			animated_sprite.play("front") 

	if velocity == Vector2.ZERO:
		animated_sprite.stop()

	position += velocity * delta

	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		is_knocked_back = true
		knockback_timer = knockback_duration
