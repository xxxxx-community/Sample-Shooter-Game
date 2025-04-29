class_name Player extends Node2D

@export var weapons: Array[Weapon] = []
@export var weapons_node_container: Node2D
@export var current_weapon_index: int
@export var shoot_enabled: bool = true
@export var weapon_switch_enabled: bool = true
@export_category("Health")
@export var health: int
@export var max_health: int

signal health_reduced(old_health: int, new_health: int)
signal health_replenished(old_health: int, new_health: int)
signal damage_took(old_health: int, new_health: int)

func _enter_tree() -> void:
	GlobalVars.player = self
	health = clamp(health, 1, max_health)


func _ready():
	if weapons_node_container:
		weapons.append_array(weapons_node_container.get_children())


func _process(_delta):
	if GlobalVars.process_enabled:
		if weapon_switch_enabled:
			if Input.is_action_just_pressed("weapon_1"):
				current_weapon_index = 0
		
		if Input.is_action_just_pressed("shoot") and shoot_enabled:
			var shoot_deg_angle = rad_to_deg((get_global_mouse_position() - global_position).normalized().angle())
			var current_weapon = weapons[current_weapon_index]
			current_weapon.shoot(shoot_deg_angle)


func reduce_health(count: int) -> int:
	var old_health = int(health)
	health = clamp(health + count, 0, max_health)
	health_reduced.emit(old_health, health)
	if health == 0:
		GlobalVars.is_game_over = true
	return health


func take_damage(damage: int) -> int:
	damage_took.emit(health, reduce_health(-damage))
	return health
	

func replenish_health(count: int) -> int:
	health_replenished.emit(health, reduce_health(count))
	return health
