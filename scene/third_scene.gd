extends Node2D

@onready var laddoo_out_side_plate: TextureButton = $UI/LaddooOutSidePlate
@onready var laddoo_out_side_plate_two: TextureButton = $UI/LaddooOutSidePlateTwo
@onready var laddoo_out_side_three: TextureButton = $UI/LaddooOutSideThree

@onready var banner_sound_one: AudioStreamPlayer = $BannerSoundOne
@onready var banner_sound_two: AudioStreamPlayer = $BannerSoundTwo
@onready var dialog_sound: AudioStreamPlayer = $DialogSound
@onready var pressed_sound: AudioStreamPlayer = $PressedSound
@onready var right_answer: AudioStreamPlayer = $RightAnswer
@onready var wrong_answer: AudioStreamPlayer = $WrongAnswer

@onready var circle_dots: TextureRect = $UI/Plate/CircleDots
@onready var circle_dots_2: TextureRect = $UI/Plate/CircleDots2
@onready var circle_dots_3: TextureRect = $UI/Plate/CircleDots3

@onready var laddoo_in_side_plate: TextureRect = $UI/Plate/LaddooInSidePlate
@onready var laddoo_in_side_plate_two: TextureRect = $UI/Plate/LaddooInSidePlateTwo
@onready var laddoo_in_side_plate_three: TextureRect = $UI/Plate/LaddooInSidePlateThree

@onready var sound_button: TextureButton = $UI/SoundButton
@onready var home_button: TextureButton = $UI/HomeButton
@onready var banner_text_board: TextureRect = $UI/Banner/BannerTextBoard
@onready var dialog_box: TextureRect = $UI/BheemCharacter/DialogBox

var placed_count := 0
var is_busy := false

var outside_laddoos: Array[TextureButton] = []
var inside_laddoos: Array[TextureRect] = []
var circle_dots_list: Array[TextureRect] = []

const TOTAL_LADDOOS := 3


func _ready() -> void:
	inside_laddoos = [laddoo_in_side_plate, laddoo_in_side_plate_two, laddoo_in_side_plate_three]
	circle_dots_list = [circle_dots, circle_dots_2, circle_dots_3]
	outside_laddoos = [laddoo_out_side_plate, laddoo_out_side_plate_two, laddoo_out_side_three]

	laddoo_out_side_plate.visible = true
	laddoo_out_side_plate_two.visible = true
	laddoo_out_side_three.visible = true

	for in_laddoo in inside_laddoos:
		in_laddoo.visible = false
	for dot in circle_dots_list:
		dot.visible = true

	# shuru me laddoo buttons disable kar do jab tak intro khatam na ho
	_set_laddoos_disabled(true)
	banner_text_board.visible = false
	dialog_box.visible = false

	await _play_intro_banner()

	_set_laddoos_disabled(false)


func _play_intro_banner() -> void:
	# banner_text_board dikhega aur hamesha visible rahega (hide nahi hoga)
	banner_text_board.visible = true

	await MusicManager.play_and_wait(banner_sound_one)
	await MusicManager.play_and_wait(banner_sound_two)

	# ab dialog_box dikhega, dialog_sound bajega, khatam hote hi dialog_box hide ho jayega
	dialog_box.visible = true
	await MusicManager.play_and_wait(dialog_sound)
	dialog_box.visible = false


func _set_laddoos_disabled(value: bool) -> void:
	is_busy = value
	for btn in outside_laddoos:
		btn.disabled = value


# button jise click kiya, usi ko hide karta hai
# plate ka agla (left-to-right) slot fill karta hai counter ke basis pe
func _place_next_laddoo(clicked_button: TextureButton) -> void:
	if is_busy or placed_count >= TOTAL_LADDOOS:
		return # plate already full ya intro chal raha hai

	# jo bhi button click hua sirf wahi disappear hoga
	clicked_button.visible = false

	# plate hamesha left -> right sequence me fill hoga
	inside_laddoos[placed_count].visible = true
	circle_dots_list[placed_count].visible = false

	placed_count += 1

	if placed_count >= TOTAL_LADDOOS:
		await _on_plate_complete()


func _on_plate_complete() -> void:
	print("Plate of three complete!")
	_set_laddoos_disabled(true)

	right_answer.play()
	await right_answer.finished

	# yahan agli scene pe jaana ho to uncomment karo
	get_tree().change_scene_to_file("res://scene/result_screen.tscn")


func _on_laddoo_out_side_plate_pressed() -> void:
	print("LEFT button clicked")
	_place_next_laddoo(laddoo_out_side_plate)


func _on_laddoo_out_side_plate_two_pressed() -> void:
	print("MIDDLE button clicked")
	_place_next_laddoo(laddoo_out_side_plate_two)


func _on_laddoo_out_side_three_pressed() -> void:
	print("RIGHT button clicked")
	_place_next_laddoo(laddoo_out_side_three)


func _on_sound_button_pressed() -> void:
	pressed_sound.play()
	MusicManager.toggle_music()
	MusicManager.splash_icon(sound_button)
	MusicManager.sync_sound_button(sound_button)


func _on_home_button_pressed() -> void:
	pressed_sound.play()
	MusicManager.splash_icon(home_button)
	get_tree().change_scene_to_file("res://scene/main.tscn")
