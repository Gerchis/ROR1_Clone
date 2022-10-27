extends Node
class_name Stats

export var base_speed : float
export var base_accel : float
export var base_jump_force : float
export var base_max_jumps : int
export var base_gravity : float
export var base_fire_rate : float
export var base_stairs_speed : float
export var base_shooting_speed : float
export var base_shoot_damage : float

var speed_mod : float = 1
var accel_mod : float = 1
var jump_force_mod : float = 1
var max_jumps_mod : int = 0
var gravity_mod : float = 1
var fire_rate_mod : float = 1
var stairs_speed_mod : float = 1
var shooting_speed_mod : float = 1
var shoot_damage_mod : float = 1

func get_speed()->float:
	return base_speed * speed_mod

func get_accel()->float:
	return base_accel * accel_mod

func get_jump_force()->float:
	return base_jump_force * jump_force_mod

func get_max_jumps()->int:
	return base_max_jumps + max_jumps_mod

func get_gravity()->float:
	return base_gravity * gravity_mod

func get_fire_rate()->float:
	return base_fire_rate * fire_rate_mod

func get_stairs_speed()->float:
	return base_stairs_speed * stairs_speed_mod

func get_shooting_speed()->float:
	return base_shooting_speed * shooting_speed_mod

func get_shoot_damage()->float:
	return base_shoot_damage * shoot_damage_mod
