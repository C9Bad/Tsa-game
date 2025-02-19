extends Area2D

signal collected(character)  # Signal for when a player picks up the revive star

func _ready():
	# Ensure the 'area_entered' signal is connected
	if not is_connected("area_entered", Callable(self, "_on_area_entered")):
		connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D) -> void:
	print("⭐ Revive Star touched by:", area.name)  # Debugging

	# Ensure it's one of the player characters
	if area.name == "Character 1" or area.name == "Character 2":
		print("✨ Revive Star collected by:", area.name)  # Debugging
		emit_signal("collected", area)  # Emit signal to revive the character
		queue_free()  # Remove the revive star after collection
