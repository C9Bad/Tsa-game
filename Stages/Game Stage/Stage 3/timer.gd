extends VideoStreamPlayer

@export var slide_in_duration: float = 0.7
@export var fade_out_duration: float = 1.0
@export var start_offset: float = 100
@export var target_padding: float = 20

var time_left: int = 30
var timer_slid_in: bool = false
var timer_fading_out: bool = false

func _ready():
	var screen_size = get_viewport_rect().size
	position.x = screen_size.x + start_offset
	position.y = 20

	visible = false

func update_timer():
	if time_left < 30 and not timer_slid_in:
		visible = true
		timer_slid_in = true
		paused = false
		slide_in()

	time_left -= 1
	
	if time_left == 1 and not timer_fading_out:
		timer_fading_out = true
		hide_timer()

func slide_in():
	var screen_size = get_viewport_rect().size
	var target_x = screen_size.x - size.x - target_padding
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:x", target_x, slide_in_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func hide_timer():
	var tween = get_tree().create_tween()
	
	tween.tween_property(self, "modulate:a", 0.0, 1)
