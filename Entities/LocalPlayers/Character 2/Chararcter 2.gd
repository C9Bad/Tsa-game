extends CharacterBody2D

@export var speed: float = 200.0  # Movement speed

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("p2_up"):
		velocity.y = -1
	elif Input.is_action_pressed("p2_down"):
		velocity.y = 1

	if Input.is_action_pressed("p2_left"):
		velocity.x = -1
		animated_sprite.play("side") 
		animated_sprite.flip_h = true 
	elif Input.is_action_pressed("p2_right"):
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
	
	move_and_slide()

func spawn_falling_animation():
	var target_position = animated_sprite.position
	animated_sprite.global_position.y = -100  
	animated_sprite.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(animated_sprite, "position", target_position, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	await tween.finished
	
	speed = 200
