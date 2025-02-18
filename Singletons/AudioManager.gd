extends Node

var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Music"  
	music_player.stream = preload("res://Assets/Sounds/Background-Music.ogg")
	music_player.volume_db = -30
	music_player.play()
