extends Node2D

@onready var sound_button: TextureButton = $UI/SoundButton
@onready var back_button: TextureButton = $UI/BackButton

@onready var pressed_sound: AudioStreamPlayer = $PressedSound
@onready var right_answer: AudioStreamPlayer = $RightAnswer
@onready var wrong_answer: AudioStreamPlayer = $WrongAnswer

@onready var bell_three_hidden: TextureRect = $UI/BellThreeHidden
@onready var bell_three_un_hidden: TextureRect = $UI/BellThreeUnHidden
@onready var bell_one: TextureRect = $UI/BellOne
@onready var bell_two: TextureRect = $UI/BellTwo

@onready var one: TextureButton = $UI/Banner/One
@onready var two: TextureButton = $UI/Banner/Two
@onready var three: TextureButton = $UI/Banner/Three

@onready var one_sound: AudioStreamPlayer = $OneSound
@onready var two_sound: AudioStreamPlayer = $TwoSound
@onready var three_sound: AudioStreamPlayer = $ThreeSound

@onready var dialog_box_two: TextureRect = $UI/BheemCharacter/DialogBoxTwo
@onready var dialog_box_one: TextureRect = $UI/ChurkiCharacter/DialogBoxOne
@onready var dialog_box_one_sound: AudioStreamPlayer = $DialogBoxOneSound
@onready var dialog_box_second_sound: AudioStreamPlayer = $DialogBoxSecondSound


var is_busy := false


func _ready() -> void:
	# game start hote hi number buttons disable kar do jab tak dialogs khatam na ho
	_set_numbers_disabled(true)

	# dono dialog boxes shuru me hide kar do
	dialog_box_one.visible = false
	dialog_box_two.visible = false

	await _play_intro_dialogs()

	# dialogs khatam hone ke baad hi numbers enable honge
	_set_numbers_disabled(false)


func _play_intro_dialogs() -> void:
	# pehla dialog dikhao aur uska sound khatam hone tak wait karo
	dialog_box_one.visible = true
	await MusicManager.play_and_wait(dialog_box_one_sound)
	dialog_box_one.visible = false

	# phir doosra dialog dikhao aur uska sound khatam hone tak wait karo
	dialog_box_two.visible = true
	await MusicManager.play_and_wait(dialog_box_second_sound)
	dialog_box_two.visible = false


func _set_numbers_disabled(value: bool) -> void:
	is_busy = value
	one.disabled = value
	two.disabled = value
	three.disabled = value


func _on_sound_button_pressed() -> void:
	pressed_sound.play()
	MusicManager.toggle_music()
	MusicManager.splash_icon(sound_button)
	MusicManager.sync_sound_button(sound_button)


func _on_home_button_pressed() -> void:
	pressed_sound.play()
	MusicManager.splash_icon(back_button)
	get_tree().change_scene_to_file("res://scene/main.tscn")


func _on_one_pressed() -> void:
	if is_busy:
		return
	_set_numbers_disabled(true)

	one_sound.play()
	MusicManager.splash_icon(one)
	MusicManager.scale_up_and_back(bell_one)

	await one_sound.finished
	_set_numbers_disabled(false)


func _on_two_pressed() -> void:
	if is_busy:
		return
	_set_numbers_disabled(true)

	two_sound.play()
	MusicManager.splash_icon(two)
	MusicManager.scale_up_and_back(bell_two)

	await two_sound.finished
	_set_numbers_disabled(false)


func _on_three_pressed() -> void:
	if is_busy:
		return
	_set_numbers_disabled(true)

	bell_three_hidden.visible = false
	bell_three_un_hidden.visible = true
	three_sound.play()
	MusicManager.splash_icon(three)
	MusicManager.scale_up_and_back(bell_three_un_hidden)
	await three_sound.finished
	right_answer.play()
	await right_answer.finished

	_set_numbers_disabled(false)
	get_tree().change_scene_to_file("res://scene/second_scene.tscn")
	
