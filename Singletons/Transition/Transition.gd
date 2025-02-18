extends CanvasLayer

@onready var shader_material = $Control/Sprite2D.material

var next_scene = ""
var is_transitioning = false

func _ready():
	hide()
	shader_material.set_shader_parameter("progress", 1.5)
	shader_material.set_shader_parameter("fade", 0.0)

func zoom_to_scene(target_scene: String):
	if is_transitioning:
		return
		
	is_transitioning = true
	next_scene = target_scene
	
	show()
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(shader_material, "shader_parameter/progress", 0.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(shader_material, "shader_parameter/fade", 1.0, 1.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	
	await tween.finished
	
	await get_tree().create_timer(1).timeout
	
	get_tree().change_scene_to_file(next_scene)
	
	show()
	
	shader_material.set_shader_parameter("progress", 0.0)
	shader_material.set_shader_parameter("fade", 1.0)
	
	var tween_back = get_tree().create_tween()
	
	tween_back.tween_property(shader_material, "shader_parameter/progress", 1.5, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween_back.parallel().tween_property(shader_material, "shader_parameter/fade", 0.0, 1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	
	await tween_back.finished
	
	hide()
	is_transitioning = false
