extends Node2D
class_name Corridor

var door_points: Array[Vector2i]

func _ready() -> void:
	add_to_group("corridors")
	var doors = $Doors
	
	for pos in doors.get_used_cells():
		door_points.append(pos)
	
	hide_markers()


func hide_markers():
	$Doors.visible = false

func get_random_valid_door() -> Vector2i:
	return door_points[0]
