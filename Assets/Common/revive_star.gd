extends Area2D

signal collected(character)

func _ready():
	if not is_connected("area_entered", Callable(self, "_on_area_entered")):
		connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Character 1" or area.name == "Character 2":
		emit_signal("collected", area)
		queue_free()
