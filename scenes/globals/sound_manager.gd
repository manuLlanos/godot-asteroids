extends Node

# audio singleton for level sounds

var dict: Dictionary

func _ready():
	for sound: AudioStreamPlayer in get_children():
		dict[sound.name] = sound

func play(sound: String):
	if sound in dict:
		dict[sound].play()
	else:
		push_error(sound, " NOT IN AUDIO SINGLETON")

func stop(sound: String):
	if sound in dict:
		dict[sound].stop()
	else:
		push_error(sound, " NOT IN AUDIO SINGLETON")

func play_loop(sound: String):
	if sound in dict:
		if !dict[sound].playing:
			dict[sound].play()
	else:
		push_error(sound, " NOT IN AUDIO SINGLETON")
