class_name Weapon extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shoot_timer: Timer = $Timers/ShootTimer

@export var weapon_name: String
@export var weapon_bullet: PackedScene
@export var spread_angle: float
@export var shoot_delay: float

var can_shoot: bool = true

signal shot(deg_angle_with_spread: float)

func _ready():
	GlobalVars.game_over.connect(func (): shoot_timer.paused = true)
	GlobalVars.paused.connect(func (): shoot_timer.paused = true)
	GlobalVars.resume.connect(func (): shoot_timer.paused = false)


func get_deg_angle_with_spread(deg_angle: float) -> float:
	var min_deg_angle = deg_angle - spread_angle / 2.0
	var max_deg_angle = deg_angle + spread_angle / 2.0
	return randf_range(min_deg_angle, max_deg_angle)


func _process(_delta):
	look_at(get_global_mouse_position())

func shoot(deg_angle: float) -> void:
	if GlobalVars.process_enabled and can_shoot:
		var deg_angle_with_spread = get_deg_angle_with_spread(deg_angle)
		var bullet: Bullet = weapon_bullet.instantiate()
		bullet.move_direction = Vector2.from_angle(deg_to_rad(deg_angle_with_spread))
		bullet.global_position = global_position
		bullet.movement_enabled = true
		GlobalVars.world.bullets_node_container.add_child(bullet)
		shot.emit(deg_angle_with_spread)
		can_shoot = false
		shoot_timer.start(shoot_delay)


func _on_shoot_timer_timeout() -> void:
	can_shoot = true
