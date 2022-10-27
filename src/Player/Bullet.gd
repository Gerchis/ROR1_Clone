extends Area2D

export var speed := 800

func _process(delta):
	translate(global_transform.basis_xform(Vector2(speed*delta,0.0)))

func _on_Bullet_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Enemy"):
		var enemy = body as Enemy
		
		enemy.health -= GameManager.player.stats.get_shoot_damage()
		SignalManager.emit_signal("damage_to_enemy",body, 1.0)
	
	queue_free()

func _on_Lifespan_timeout():
	queue_free()
