extends Node2D

var player : PlayerController
var fire_timer := 0.0

export var bullet : PackedScene

func _ready():
	player = get_parent()

func _process(delta):
	fire_timer += delta
	scale.y = -1 if player.sprite.flip_h else 1

func shoot(is_shooting:bool):
	if is_shooting and fire_timer > player.stats.get_fire_rate():
		fire_timer = 0.0
		var instance = bullet.instance()
		
		add_child(instance)
		instance.set_as_toplevel(true)
		instance.global_position = $Sprite/Cannon.global_position
		instance.global_rotation = $Sprite/Cannon.global_rotation
