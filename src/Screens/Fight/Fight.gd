extends Node2D

var UIDieClass = preload("res://Things/UIDie/UIDie.tscn")
var DieClass = preload("res://Things/Die/Die.tscn")

const MAX_THROWS: int = 3
const MAX_DICE_SAVED: int = 4


onready var _shaders: Control = $CanvasLayer/Shaders
onready var _dice: Node2D = $DiceTray/Dice
onready var _dice_tray: DiceTray = $DiceTray
onready var _saved_diece: Control = $CanvasLayer/UI/HBoxContainer/CenterContainer/VBoxContainer/CenterContainer/SavedDice
onready var _throw_label: Label = $CanvasLayer/UI/HBoxContainer/CenterContainer/VBoxContainer/CenterContainer2/ThrowLabel
onready var _roll_button: Button = $CanvasLayer/UI/HBoxContainer/VBoxContainer/RollButton

var _throw_number: int = 0

func _ready() -> void:
	randomize()

	update_throws_label()
	_shaders.visible = true
	connect_dice()

	throw_all_dice()


func throw_all_dice():
	for die in _dice.get_children():
		die.throw()

	_throw_number += 1
	update_throws_label()

	_roll_button.disabled = _throw_number == MAX_THROWS


func connect_dice():
	for die in _dice.get_children():
		die.connect("clicked", self, "save_die")


func save_die(die: Die):
	if _saved_diece.get_child_count() >= MAX_DICE_SAVED:
		return

	var new_ui_die: UIDie = UIDieClass.instance()
	new_ui_die.type = die.type
	_saved_diece.add_child(new_ui_die)
	new_ui_die.connect("clicked", self, "unsave_die")

	die.queue_free()


func unsave_die(ui_die: UIDie):
	var new_die: Die = DieClass.instance()
	new_die.type = ui_die.type
	_dice_tray.add_die(new_die)
	new_die.throw(false)
	new_die.connect("clicked", self, "save_die")

	ui_die.queue_free()


func _on_RollButton_pressed() -> void:
	throw_all_dice()


func update_throws_label():
	_throw_label.text = "Throws: " + str(_throw_number) + "/" + str(MAX_THROWS)


func _on_EndTurnButton_pressed() -> void:
	_throw_number = 0

	# Calculate outcome
	# Enemy attack
	# Spawn new dice

	for ui_die in _saved_diece.get_children():
		var new_die: Die = DieClass.instance()
		new_die.type = ui_die.type
		_dice.add_child(new_die)

		ui_die.queue_free()
		_saved_diece.remove_child(ui_die)

	connect_dice()


	throw_all_dice()
