extends Node2D

@onready var winner_sound: AudioStreamPlayer = $WinnerSound
@onready var banner_sound: AudioStreamPlayer = $BannerSound
@onready var pressed_sound: AudioStreamPlayer = $PressedSound

@onready var home_button: TextureButton = $UI/HomeButton
@onready var replay_button: TextureButton = $UI/ReplayButton

var is_busy := false


func _ready() -> void:
	_set_buttons_disabled(true)

	await _play_intro_sounds()

	_set_buttons_disabled(false)


func _play_intro_sounds() -> void:
	# pehle winner sound, khatam hone tak wait
	await MusicManager.play_and_wait(winner_sound)

	# phir banner sound, uska bhi wait
	await MusicManager.play_and_wait(banner_sound)


func _set_buttons_disabled(value: bool) -> void:
	is_busy = value
	home_button.disabled = value
	replay_button.disabled = value


func _on_home_button_pressed() -> void:
	if is_busy:
		return
	pressed_sound.play()
	MusicManager.splash_icon(home_button)
	get_tree().change_scene_to_file("res://scene/main.tscn")


func _on_replay_button_pressed() -> void:
	if is_busy:
		return
	pressed_sound.play()
	MusicManager.splash_icon(replay_button)
	get_tree().change_scene_to_file("res://scene/first_scene.tscn")
