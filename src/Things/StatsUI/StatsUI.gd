extends VBoxContainer
class_name StatsUI


onready var _monster_name: Label = $Monster/MonsterName
onready var _monster_health: HealthBar = $Monster/MonsterStats/HBoxContainer/HealthBar
onready var _monster_defence: Label = $Monster/MonsterStats/HBoxContainer2/MonsterDefence
onready var _monster_attack: Label = $Monster/MonsterStats/HBoxContainer3/MonsterAttack

onready var _hero_health: HealthBar = $Hero/HeroStats/HBoxContainer/HealthBar


func load_stats(hero_health: int, enemy: EnemyDefinition):
	_hero_health.max_value = hero_health

	_monster_health.max_value = enemy.health
	_monster_name.text = enemy.name
	_monster_defence.text = str(enemy.defence)
	_monster_attack.text = str(enemy.attack)


func change_monster_health(value: int):
	_monster_health.change_value(value)


func change_hero_health(value: int):
	_hero_health.change_value(value)
