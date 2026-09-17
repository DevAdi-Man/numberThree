extends Node2D


@onready var sound_button: TextureButton = $UI/SoundButton
@onready var pressed_sound: AudioStreamPlayer = $PressedSound
@onready var button_background: TextureButton = $UI/ButtonBackground

func _on_sound_button_pressed() -> void:
	pressed_sound.play()
	MusicManager.toggle_music()
	MusicManager.splash_icon(sound_button)
	MusicManager.sync_sound_button(sound_button)


func _on_button_background_pressed() -> void:
	pressed_sound.play()
	MusicManager.scale_up_and_back(button_background,1.02,1.2)
	await pressed_sound.finished
	get_tree().change_scene_to_file("res://scene/first_scene.tscn")
