extends Node2D

@onready var question_title: Label = $UI/Banner/QuestionTitle
@onready var three_number: Label = $UI/Banner/ThreeNumber
@onready var instruction: Label = $UI/Banner/Instruction

@onready var banner_sound_one: AudioStreamPlayer = $BannerSoundOne
@onready var banner_sound_two: AudioStreamPlayer = $BannerSoundTwo

@onready var cow_button: TextureButton = $UI/BoxContainer/CowButton
@onready var bag_button: TextureButton = $UI/BoxContainer/BagButton
@onready var candy_button: TextureButton = $UI/BoxContainer/CandyButton

@onready var sound_button: TextureButton = $UI/SoundButton
@onready var home_button: TextureButton = $UI/HomeButton

@onready var pressed_sound: AudioStreamPlayer = $PressedSound
@onready var right_answer: AudioStreamPlayer = $RightAnswer
@onready var wrong_answer: AudioStreamPlayer = $WrongAnswer

var is_busy := false


func _ready() -> void:
	_set_buttons_disabled(true)

	# shuru me dono chize hide kar do
	question_title.visible = false
	three_number.visible = false
	instruction.visible = false

	await _play_intro_banners()

	_set_buttons_disabled(false)


func _play_intro_banners() -> void:
	# question_title aur three_number ek saath dikhenge banner_sound_one ke saath
	question_title.visible = true
	three_number.visible = true
	await MusicManager.play_and_wait(banner_sound_one)

	# phir instruction dikhega banner_sound_two ke saath
	instruction.visible = true
	await MusicManager.play_and_wait(banner_sound_two)


func _set_buttons_disabled(value: bool) -> void:
	is_busy = value
	cow_button.disabled = value
	bag_button.disabled = value
	candy_button.disabled = value


func _on_cow_button_pressed() -> void:
	if is_busy:
		return
	shake_node(cow_button)
	wrong_answer.play()
	await wrong_answer.finished


func _on_bag_button_pressed() -> void:
	if is_busy:
		return
	shake_node(bag_button)
	wrong_answer.play()
	await wrong_answer.finished


func _on_candy_button_pressed() -> void:
	if is_busy:
		return
	_set_buttons_disabled(true)

	MusicManager.scale_up_and_back(candy_button)
	right_answer.play()
	await right_answer.finished
	get_tree().change_scene_to_file("res://scene/third_scene.tscn")


func _on_home_button_pressed() -> void:
	pressed_sound.play()
	MusicManager.splash_icon(home_button)
	get_tree().change_scene_to_file("res://scene/main.tscn")


func _on_sound_button_pressed() -> void:
	pressed_sound.play()
	MusicManager.toggle_music()
	MusicManager.splash_icon(sound_button)
	MusicManager.sync_sound_button(sound_button)


func shake_node(node: TextureButton, strength: float = 10.0, duration: float = 0.4) -> void:
	var original_position := node.position
	var tween := create_tween()

	var shakes := 6
	for i in range(shakes):
		var offset := Vector2(randf_range(-strength, strength), randf_range(-strength, strength))
		tween.tween_property(node, "position", original_position + offset, duration / shakes)

	tween.tween_property(node, "position", original_position, duration / shakes)
