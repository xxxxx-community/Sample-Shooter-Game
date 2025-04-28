class_name Obstacle extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var health_label: Label = $HealthLabel

@export_category("Health")
@export var max_health: int = 1
@export var health: int = 1:
	set(value):
		var new_health = clamp(value, 0, max_health)
		health_changed.emit(health, new_health)
		health = new_health
@export var show_health_label: bool = false:
	set(value):
		show_health_label = value
		if health_label:
			health_label.visible = show_health_label

@export_category("Movement")
@export var speed: float
@export var move_direction: Vector2 = Vector2.DOWN
@export var movement_smoothing: float = 0.1
@export var movement_enabled: bool = true

signal hit(by: Bullet)
signal health_changed(old_health: int, new_health: int)
signal destroyed()

func _ready():
	health = clamp(health, 0, max_health)
	move_direction = move_direction.normalized() if not move_direction.is_normalized() else move_direction
	GlobalVars.paused.connect(func (): animation_player.pause())
	GlobalVars.resume.connect(func (): animation_player.play())
	GlobalVars.game_over.connect(func (): animation_player.stop())
	animation_player.play("idle")


func _process(_delta):
	if GlobalVars.process_enabled:
		if movement_enabled:
			velocity = velocity.lerp(
				move_direction * speed,
				movement_smoothing
			)
		else:
			velocity = Vector2.ZERO

		move_and_slide()


func take_damage_by_bullet(bullet: Bullet) -> void:
	health -= bullet.damage
	hit.emit(bullet)
	animation_player.play("hit")
	if health == 0:
		destroyed.emit()


func _on_health_changed(_old_health: int, new_health: int) -> void:
	if health_label:
		health_label.text = "%s/%s" % [new_health, max_health]


func _on_destroyed() -> void:
	animation_player.play("destroy")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"hit":
			animation_player.play("idle")
		"destroy":
			queue_free()
