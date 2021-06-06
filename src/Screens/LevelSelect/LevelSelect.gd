extends Control
class_name LevelSelect


signal enemy_selected(enemy, level)


export(int) var num_defeated_enemies: int = 0



onready var _prot1: TextureRect = $CenterContainer/VBoxContainer/SkullyBoy/CenterContainer/Portrait
onready var _question1: Label = $CenterContainer/VBoxContainer/SkullyBoy/CenterContainer/Label
onready var _button1: Button = $CenterContainer/VBoxContainer/SkullyBoy/CenterContainer2/SkullyButton
onready var _prot2: TextureRect = $CenterContainer/VBoxContainer/DerpyDragon/CenterContainer/Portrait
onready var _question2: Label = $CenterContainer/VBoxContainer/DerpyDragon/CenterContainer/Label
onready var _button2: Button = $CenterContainer/VBoxContainer/DerpyDragon/CenterContainer2/DerpyButton

onready var _click_audio: AudioStreamPlayer = $ClickAudio


func _ready() -> void:
	init()


func init():
	if num_defeated_enemies > 0:
		_prot1.visible = true
		_question1.visible = false
		_button1.visible = true
		_button1.disabled = false
	if num_defeated_enemies > 1:
		_prot2.visible = true
		_question2.visible = false
		_button2.visible = true
		_button2.disabled = false


func _on_FlappyButton_pressed() -> void:
	_click_audio.play()
	emit_signal("enemy_selected", load("res://Things/Enemy/flappy_bat.tres"), 1)


func _on_SkullyButton_pressed() -> void:
	_click_audio.play()
	emit_signal("enemy_selected", load("res://Things/Enemy/skully_boy.tres"), 2)


func _on_DerpyButton_pressed() -> void:
	_click_audio.play()
	emit_signal("enemy_selected", load("res://Things/Enemy/derpy_dragon.tres"), 3)
