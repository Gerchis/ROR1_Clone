extends KinematicBody2D
class_name Enemy

export var max_health := 100

var health := 1

func _ready():
	health = max_health

func _process(delta):
	check_death()

func check_death():
	if health <= 0:
		queue_free()

