extends Control

@onready var video_player = $VideoStreamPlayer
@onready var beep_player = $BeepSoundPlayer
@onready var beep_timer = $BeepTimer
@onready var freeze_frame = $FreezeFrame

@onready var exit_button = $Buttons/Exit
@onready var pause_button = $Buttons/Pause
@onready var play_button = $Buttons/Play

var story_sequence = [
	{ "video": "res://Assets/Story/Endpart1.ogv", "beep": "res://Assets/Sounds/ambientWind.wav" },
	{ "video": "res://Assets/Story/Endpart2.ogv", "beep": "res://Assets/Sounds/ambientWind.wav" },
	{ "video": "res://Assets/Story/Endpart3.ogv", "beep": "res://Assets/Sounds/sunflowerTalk.wav" },
	{ "video": "res://Assets/Story/Endpart4.ogv", "beep": "res://Assets/Sounds/fatTalk.wav" },
	{ "video": "res://Assets/Story/Endpart5.ogv", "beep": "res://Assets/Sounds/ambientWind.wav" },
	{ "video": "res://Assets/Story/Endpart6.ogv", "beep": "res://Assets/Sounds/ambientWind.wav" },
]

var index = 0
var autoplay = true
var autoplay_delay = 3.0
var is_paused_by_user = false
var pending_autoplay = false

func _ready():
	freeze_frame.visible = false
	beep_timer.connect("timeout", Callable(self, "_on_beep_timer_timeout"))
	_play_current()

func _play_current():
	if index >= story_sequence.size():
		Transition.zoom_to_scene("res://Stages/Stage Selector/stage_selector.tscn")
		return

	var current = story_sequence[index]
	var video_path = current.video
	var beep_path = current.beep

	video_player.stream = load(video_path)
	video_player.play()

	if beep_path:
		beep_player.stream = load(beep_path)
		beep_timer.start()
	else:
		beep_timer.stop()
		beep_player.stream = null

	freeze_frame.visible = false

	await video_player.finished

	beep_timer.stop()

	var freeze_frame_path = video_path.replace(".ogv", "_end.png")
	var tex = load(freeze_frame_path)
	freeze_frame.texture = tex
	freeze_frame.visible = true

	if autoplay:
		var delay = autoplay_delay
		if index == story_sequence.size() - 1:
			delay = 6.0 
		await get_tree().create_timer(delay).timeout
		if is_paused_by_user:
			pending_autoplay = true
		else:
			index += 1
			_play_current()


func _on_beep_timer_timeout():
	if video_player.is_playing() and beep_player.stream:
		beep_player.pitch_scale = randf_range(0.9, 1.1)
		beep_player.play()

func _on_exit_pressed() -> void:
	Transition.zoom_to_scene("res://Stages/Stage Selector/stage_selector.tscn")

func _on_pause_pressed() -> void:
	is_paused_by_user = true
	video_player.paused = true
	beep_timer.stop()

func _on_play_pressed() -> void:
	is_paused_by_user = false
	video_player.paused = false
	if beep_player.stream:
		beep_timer.start()

	# If autoplay was pending, continue to next scene now
	if pending_autoplay:
		pending_autoplay = false
		index += 1
		_play_current()
