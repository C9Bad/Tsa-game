extends Node2D

@onready var star = $Star
@onready var star2 = $Star2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	star.play("default")
	star2.play("default")
