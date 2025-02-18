extends Control  

var stage_data

@onready var stage_map = $Sign

func _ready() -> void:
	stage_data = Globalvars.stage_data
	set_correct_texture()

func set_correct_texture():
	var latest_stage = get_latest_nonzero_stage()
	if latest_stage == null:
		print("No completed stages found.")
		return

	var stars = stage_data[latest_stage]
	var stage_number = latest_stage.trim_prefix("stage_")  

	var image_path = "res://Assets/Stage Selection/Map" + str(stage_number) + "starstage" + str(stars) + ".PNG"
	
	stage_map.texture = load(image_path)

func get_latest_nonzero_stage():
	var latest_stage = null
	for stage in stage_data.keys():
		if stage_data[stage] > 0:
			latest_stage = stage  
	return latest_stage
