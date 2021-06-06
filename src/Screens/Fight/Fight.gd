extends Node2D

var UIDieClass = preload("res://Things/UIDie/UIDie.tscn")
var DieClass = preload("res://Things/Die/Die.tscn")

const MAX_THROWS: int = 3
const MAX_DICE_SAVED: int = 4
const HERO_MAX_HEALTH: int = 20

export(Resource) var enemy_definition = enemy_definition as EnemyDefinition

onready var _shaders: Control = $CanvasLayer/Shaders
onready var _dice: Node2D = $DiceTray/Dice
onready var _dice_tray: DiceTray = $DiceTray
onready var _saved_diece: Control = $CanvasLayer/UI/HBoxContainer/CenterContainer/VBoxContainer/CenterContainer/SavedDice
onready var _throw_label: Label = $CanvasLayer/UI/HBoxContainer/CenterContainer/VBoxContainer/CenterContainer2/ThrowLabel
onready var _roll_button: Button = $CanvasLayer/UI/HBoxContainer/VBoxContainer/RollButton
onready var _end_turn_button: Button = $CanvasLayer/UI/HBoxContainer/VBoxContainer/EndTurnButton
onready var _stats_ui: StatsUI = $CanvasLayer/UI/Stats
onready var _phase_timer: Timer = $PhaseTimer
onready var _enemy: Enemy = $Enemy

var _hero_health: int = HERO_MAX_HEALTH

var _monster_health: int = 10

var _throw_number: int = 0
var _is_end_turn: bool = false

func _ready() -> void:
	randomize()

	_stats_ui.load_stats(_hero_health, enemy_definition)
	_monster_health = enemy_definition.health

	_enemy.load_enemy(enemy_definition)

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


func get_outcome() -> Array:
	var outcome: Array = [0, 0, 0]

	for die in _dice.get_children():
		outcome[die.type] += 1
	for ui_die in _saved_diece.get_children():
		outcome[ui_die.type] += 1

	return outcome


func _on_EndTurnButton_pressed() -> void:
	_is_end_turn = true
	_roll_button.disabled = true
	_end_turn_button.disabled = true

	_throw_number = 0

	# Calculate outcome
	var outcome: Array = get_outcome()

	### ATTACK MONSTER
	var hero_attack: int = outcome[0] - enemy_definition.defence
	# Play monster animation + sound
	if hero_attack > 0:
		_enemy.play_damage_animation()
		_monster_health -= hero_attack
		_stats_ui.change_monster_health(_monster_health)

	_phase_timer.start()
	yield(_phase_timer, "timeout")

	### HEAL HERO
	_hero_health = clamp(_hero_health + outcome[1], 0, HERO_MAX_HEALTH)
	_stats_ui.change_hero_health(_hero_health)
	# Play heal animation + sound

	_phase_timer.start()
	yield(_phase_timer, "timeout")

	### ATTACK HERO
	var monster_attack: int = enemy_definition.attack - outcome[2]
	_enemy.play_attack_animation()
	if monster_attack > 0:
		_hero_health -= monster_attack
		_stats_ui.change_hero_health(_hero_health)
	# Play monster animation + sound

	_phase_timer.start()
	yield(_phase_timer, "timeout")

	# Spawn new dice
	for ui_die in _saved_diece.get_children():
		var new_die: Die = DieClass.instance()
		new_die.type = ui_die.type
		_dice_tray.add_die(new_die)

		ui_die.queue_free()
		_saved_diece.remove_child(ui_die)

	connect_dice()
	throw_all_dice()

	_is_end_turn = false
	_roll_button.disabled = false
	_end_turn_button.disabled = false
