extends Camera2D

export var max_offset := -1.0
export var min_offset := 1.0

func _process(delta):
	if get_vertical_input() != 0:
		if get_vertical_input() < 0:
			offset_v = max_offset
		else:
			offset_v = min_offset
	else:
		offset_v = 0

func get_vertical_input():
	var result = Input.get_axis("up","down")
	return result if abs(result) > 0.2 else 0
