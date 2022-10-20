extends Node

const MAX_GRAVITY_FORCE = 1000.0
var init_stats = preload("res://src/Resources/Init_Player_Stats.tres")
var player:PlayerController

func set_player(new_player:PlayerController):
	player = new_player

func get_new_player_stats():
	var new_stats = Stats.new()
	
	new_stats.speed = init_stats.speed
	new_stats.accel = init_stats.accel
	new_stats.jump_force = init_stats.jump_force
	new_stats.max_jumps = init_stats.max_jumps
	new_stats.gravity = init_stats.gravity
	new_stats.fire_rate = init_stats.fire_rate
	new_stats.stairs_speed = init_stats.stairs_speed
	new_stats.shoot_speed = init_stats.shoot_speed
	new_stats.shoot_damage = init_stats.shoot_damage
	
	return new_stats
