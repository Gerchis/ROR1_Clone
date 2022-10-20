extends Node

var player : PlayerController
var enemy : KinematicBody2D
var velocity := Vector2.ZERO
var direction := -1
var is_agro := false

export var gravity := 800.0
export var jump_force := 170.0
export var speed := 200.0
export var agro_distance := 100.0
export var calm_distance := 300.0
export var vertical_knockup := 300.0
export var horizontal_knockup := 600.0


func _ready():
	enemy = get_parent()
	player = GameManager.player
	
	SignalManager.connect("damage_to_enemy", self, "debug_text")

func _physics_process(delta):
	apply_gravity(delta)
	movement()
	
	velocity = enemy.move_and_slide(velocity, Vector2.UP)
	
	check_agro()

func apply_gravity(delta:float):
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, -GameManager.MAX_GRAVITY_FORCE, GameManager.MAX_GRAVITY_FORCE)

func _on_JumpTimer_timeout():
	set_direction()
	velocity.y = -jump_force

func movement():
	if enemy.is_on_floor():
		velocity.x = 0
	else:
		velocity.x = speed*direction

func check_agro():
	if !is_agro and enemy.global_position.distance_squared_to(player.global_position) < agro_distance*agro_distance:
		is_agro = true
	elif is_agro and  enemy.global_position.distance_squared_to(player.global_position) > calm_distance * calm_distance:
		is_agro = false

func set_direction():
	if is_agro:
		direction = 1 if player.global_position.x - enemy.global_position.x > 0 else -1

func debug_text(enemy, proc):
	print ("JJ")


func _on_Hurtbox_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Player"):
		var player = body as PlayerController
		if player.using_stairs:
			 player.detach_from_stairs()
		
		player.velocity.y = -vertical_knockup
		player.velocity.x = horizontal_knockup if (player.global_position - enemy.global_position).x > 0 else -horizontal_knockup
