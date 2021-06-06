extends RigidBody2D
class_name Die

signal clicked(Die)


const THROW_DEFAULTS: Dictionary = {
	"min": 1500,
	"max": 2500,
	"angle_margin": 1.5,
	"torque_margin": 5
}

const RANDOM_DEFAULTS: Dictionary = {
	"start_time": .01,
	"time_increase": .01,
	"num_rounds": 15,
}

onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _border: TextureRect = $Visual/Border

onready var _sword_icon: Sprite = $Visual/SwordIcon
onready var _health_icon: Sprite = $Visual/HealthIcon
onready var _shield_icon: Sprite = $Visual/ShieldIcon

var _is_throwing: bool = false

export var throw_target: Vector2 = Vector2.ZERO
export(Enums.DieType) var type = Enums.DieType.SWORD setget set_type


func _ready() -> void:
	self.type = type


func set_type(new_type: int):
	type = new_type

	if not is_instance_valid(_sword_icon): return

	_sword_icon.visible = false
	_health_icon.visible = false
	_shield_icon.visible = false

	match type:
		Enums.DieType.SWORD:
			_sword_icon.visible = true
		Enums.DieType.SHIELD:
			_shield_icon.visible = true
		Enums.DieType.HEALTH:
			_health_icon.visible = true


func throw(rand: bool = true, velocity: Vector2 = Vector2.ZERO):
	if velocity == Vector2.ZERO:
		velocity = Vector2(1, 0) * rand_range(THROW_DEFAULTS["min"], THROW_DEFAULTS["max"])
		var angle: float = get_angle_to(throw_target) + rand_range(-THROW_DEFAULTS["angle_margin"], THROW_DEFAULTS["angle_margin"])
		velocity = velocity.rotated(angle + self.rotation)

	apply_central_impulse(velocity)

	var torque: float = rand_range(-THROW_DEFAULTS["torque_margin"], THROW_DEFAULTS["torque_margin"])
	angular_velocity = torque

	if not rand: return

	_animation_player.play("Throw")
	_animation_player.seek(0, true)

	_is_throwing = true

	_border.mouse_default_cursor_shape = Control.CURSOR_ARROW

	for i in range(RANDOM_DEFAULTS["num_rounds"]):
		self.type = int(floor(rand_range(0, 3)))
		yield(get_tree().create_timer(RANDOM_DEFAULTS["start_time"] + RANDOM_DEFAULTS["time_increase"] * i), "timeout")

	_is_throwing = false

	_border.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _on_Border_gui_input(event: InputEvent) -> void:
	if event as InputEventMouseButton and not event.is_pressed() and not _is_throwing:
		emit_signal("clicked", self)
