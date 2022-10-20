extends Area2D
class_name Stairs

func _on_Stairs_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Player"):
		body.actual_stairs = self


func _on_Stairs_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Player"):
		body.actual_stairs = null
