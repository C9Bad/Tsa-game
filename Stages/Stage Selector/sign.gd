extends Sprite2D  

var stage_data

@onready var lock2 = $Control/Lock2
@onready var lock3 = $Control/Lock3

func _ready() -> void:
	stage_data = Globalvars.stage_data
	set_correct_texture()
	print("Lock2 found:", lock2)
	print("Lock3 found:", lock3)


func set_correct_texture():
	var latest_stage = get_latest_nonzero_stage()
	if latest_stage == null:
		print("No completed stages found.")
		return

	var stars = stage_data[latest_stage]
	var stage_number = latest_stage.trim_prefix("stage_")  

	var image_path = "res://Assets/Stage Selection/Map" + str(stage_number) + "starstage" + str(stars) + ".png"
	
	if ResourceLoader.exists(image_path):
		texture = load(image_path)  
	else:
		print("Image file not found:", image_path)

func get_latest_nonzero_stage():
	var latest_stage = null
	for stage in stage_data.keys():
		if stage_data[stage] > 0:
			latest_stage = stage  
	return latest_stage
