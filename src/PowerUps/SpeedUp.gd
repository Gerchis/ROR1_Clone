extends Area2D

export var speed_modifier := 0.2

func _on_SpeedUp_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		GameManager.player.stats.speed_mod += speed_modifier
		GameManager.player.stats.accel_mod += speed_modifier
		GameManager.player.stats.shooting_speed_mod += speed_modifier
		GameManager.player.stats.stairs_speed_mod += speed_modifier
		queue_free()
