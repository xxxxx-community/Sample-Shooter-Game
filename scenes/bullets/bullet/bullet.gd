class_name Bullet extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var life_timer: Timer = $Timers/LifeTimer

@export var damage: int
@export var target_groups: Array[String] = [GlobalVars.Groups.OBSTACLE]
@export var delete_after_hit: bool = true
@export var life_time: float = 5
@export_category("Movement")
@export var speed: float = 1000
@export var move_direction: Vector2

signal target_achieved()
signal deleted()
signal life_time_out()

var movement_enabled: bool = false

func _ready():
	life_timer.start(life_time)
	GlobalVars.game_over.connect(func (): life_timer.paused = true)
	GlobalVars.paused.connect(func (): life_timer.paused = true)
	GlobalVars.resume.connect(func (): life_timer.paused = false)


func _process(_delta):
	if GlobalVars.process_enabled:
		if movement_enabled:
			velocity = move_direction.normalized() * speed
		move_and_slide()


func is_target(body: Node2D) -> bool:
	for target_group in target_groups:
		if not body.is_in_group(target_group):
			return false
	return true


func _on_damage_area_body_entered(body: Node2D) -> void:
	if GlobalVars.process_enabled:
		if is_target(body):
			var obstacle: Obstacle = body
			obstacle.take_damage_by_bullet(self)
			target_achieved.emit()
			if delete_after_hit:
				deleted.emit()

func _on_life_timer_timeout() -> void:
	life_time_out.emit()


func _on_deleted() -> void:
	queue_free()


func _on_life_time_out() -> void:
	queue_free()
