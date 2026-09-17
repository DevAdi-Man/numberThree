extends Node
var music_player: AudioStreamPlayer
var is_audio_busy := false

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = preload("res://assets/sound/edugamery-music-17.mp3")
	music_player.volume_db = -15.0  # lower this to make it quieter (e.g. -20, -30)
	music_player.play()

func toggle_music() -> void:
	print("Helllo")
	if music_player.playing:
		music_player.stop()
	else:
		music_player.play()

func sync_sound_button(btn: TextureButton) -> void:
	btn.button_pressed = !music_player.playing

func splash_icon(button:TextureButton) -> void:
	var icon  := create_tween()
	icon.tween_property(button, "modulate", Color(1.3, 1.3, 1.3), 0.1)
	icon.tween_property(button, "modulate", Color(1, 1, 1), 0.2)

func scale_up_and_back(node, target_scale: float = 1.3, duration: float = 3.5) -> void:
	var original_scale: Vector2 = node.scale
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(node, "scale", Vector2(target_scale, target_scale), duration / 2)
	tween.tween_property(node, "scale", original_scale, duration / 2)

func play_and_wait(audio_player: AudioStreamPlayer) -> void:
	if is_audio_busy:
		return 
	is_audio_busy = true
	get_tree().root.set_disable_input(true)

	audio_player.play()
	await audio_player.finished

	get_tree().root.set_disable_input(false)
	is_audio_busy = false
