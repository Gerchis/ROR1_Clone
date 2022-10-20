extends KinematicBody2D
class_name PlayerController

var stats : Resource
var jumps_made : int = 0
var velocity := Vector2.ZERO
var jumping := false
var bullet_scene := PackedScene
var actual_stairs : Stairs = null
var using_stairs := false

onready var sprite = $Sprite2
onready var weapon = $BaseWeapon
onready var jump_buffer_timer = $JumpBuffer
onready var stairs_cancel_timer : Timer = $StairsCancel

func _ready():
	GameManager.set_player(self)
	stats = GameManager.get_new_player_stats()

func _process(delta):
	if is_shooting():
		weapon.show()
		check_turn(get_aim_input().x)
	else:
		weapon.hide()
		check_turn(get_horizontal_input())
	
	var aim = weapon.global_position + get_aim_input()
	weapon.look_at(aim)
	weapon.shoot(is_shooting())

func _physics_process(delta):
	var x_input = get_horizontal_input()
	set_horizontal_movement(x_input, delta)
	
	apply_gravity(delta)
	jump()
	
	if actual_stairs != null:
		use_stairs()
	
	velocity = move_and_slide(velocity, Vector2.UP)


func get_horizontal_input():
	var result = Input.get_axis("left","right")
	return result if abs(result) > 0.2 else 0

func set_horizontal_movement(input:float, delta:float):
	var target_speed = input*stats.shoot_speed if is_shooting() else input*stats.speed
	velocity.x = move_toward(velocity.x, target_speed, stats.accel*delta)

func apply_gravity(delta:float):
	velocity.y += stats.gravity * delta
	velocity.y = clamp(velocity.y, -GameManager.MAX_GRAVITY_FORCE, GameManager.MAX_GRAVITY_FORCE)

func jump():
	if is_on_floor() and jumps_made != 0 or using_stairs:
		jumps_made = 0
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()
		jumping = true
	
	if jumping and jumps_made < stats.max_jumps:
		velocity.y = -stats.jump_force
		jumps_made += 1
		jump_buffer_timer.stop()
		jumping = false

func get_vertical_input():
	var result = Input.get_axis("up","down")
	return result if abs(result) > 0.2 else 0

func get_mouse_aim():
	return get_global_mouse_position() - global_position

func get_axis_aim():
	var hor_axis = Input.get_axis("shoot_left","shoot_right")
	var vert_axis = Input.get_axis("shoot_up","shoot_down")
	
	return Vector2(hor_axis, vert_axis)

func get_aim_input():
	var free_aim = Vector2.ZERO
	
	if Input.is_action_pressed("shoot_button"):
		free_aim = get_mouse_aim()
	else:
		free_aim = get_axis_aim()
	
	if free_aim == Vector2.ZERO: return Vector2.ZERO
	
	var dot = free_aim.normalized().dot(Vector2(1.0,0.0));	
	var direction_aim = Vector2.ZERO
	
	if dot > 0.94:
		direction_aim = Vector2(1.0,0.0)
	elif dot > 0.25:
		direction_aim = Vector2(1.0,1.0)
	elif dot > -0.25:
		direction_aim = Vector2(0.0,1.0)
	elif dot > -0.94:
		direction_aim = Vector2(-1.0,1.0)
	else:
		direction_aim = Vector2(-1.0,0.0)
	
	if free_aim.y < 0:
		direction_aim.y *= -1
	
	return direction_aim.normalized()

func is_shooting():
	if Input.is_action_pressed("shoot_button") or get_aim_input() != Vector2.ZERO:
		return true
	return false

func check_turn(look_x : float):
	if look_x < 0:
		sprite.flip_h = true
	elif look_x > 0:
		sprite.flip_h = false

func _on_JumpBuffer_timeout():
	jumping = false

func detach_from_stairs():
	stairs_cancel_timer.start()
	using_stairs = false

func use_stairs():
	if is_on_floor() and get_vertical_input() > 0:
		detach_from_stairs()
	
	if Input.is_action_just_pressed("jump") and using_stairs and stairs_cancel_timer.is_stopped():
		detach_from_stairs()
		
		velocity.y = -stats.jump_force
		jumps_made += 1
	
	if get_vertical_input() != 0 and stairs_cancel_timer.is_stopped():
		using_stairs = true
		global_position.x = actual_stairs.global_position.x
	
	if using_stairs and stairs_cancel_timer.is_stopped():
		velocity.x = 0
		velocity.y = get_vertical_input()*stats.stairs_speed
