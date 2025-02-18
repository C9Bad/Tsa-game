extends VideoStreamPlayer

var stage_data

func _ready() -> void:
	stage_data = Globalvars.stage_data
	play_correct_video()

func play_correct_video():
	var latest_stage = get_latest_nonzero_stage()
	if latest_stage == null:
		print("No completed stages found.")
		return

	var stars = stage_data[latest_stage]
	var stage_number = latest_stage.trim_prefix("stage_")  # Extract stage number

	var video_path = "res://Assets/Map" + str(stage_number) + "starstage" + str(stars) + ".ogv"
	print(video_path)
	
	if ResourceLoader.exists(video_path):
		stream = load(video_path)  # Load the video file
		play()  # Start playing the video
	else:
		print("Video file not found:", video_path)

func get_latest_nonzero_stage():
	var latest_stage = null
	for stage in stage_data.keys():
		if stage_data[stage] > 0:
			latest_stage = stage  # Keep updating to the last nonzero stage
	return latest_stage
