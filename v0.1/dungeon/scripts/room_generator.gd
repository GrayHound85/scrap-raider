extends Node

class_name RoomGenerator

# Variables
var occupied := {}
var tile: int = 0

func generate_rooms(points: Array, room, gen):
	occupied = {}
	var room_centers = []
	var max_failed_attempts = 3
	var points_copy = points.duplicate()
	while points_copy.size() > 0 and max_failed_attempts > 0:
		for i in range(points_copy.size() - 1, -1, -1):
			var point = points_copy[i]
			var padding =  gen.PADDING * 2
			var room_w = randi_range(room.MIN_WIDTH, room.MAX_WIDTH)
			var room_h = randi_range(room.MIN_HEIGHT, room.MAX_HEIGHT)
			
			var tile_coord = Vector2i(
				int(round(point.x / gen.TILESIZE)),
				int(round(point.y / gen.TILESIZE))
			)
			
			@warning_ignore("integer_division")
			var top_left = tile_coord - Vector2i(room_w / 2, room_h / 2)
			
			if can_place_room(top_left, room_w, room_h):
				for x in range(room_w):
					for y in range(room_h):
						var coord = top_left + Vector2i(x,y)
						occupied[coord] = tile
				room_centers.append(point)
				points_copy.remove_at(i)
				max_failed_attempts = 3
			else:
				max_failed_attempts -= 1
	
	return [occupied, room_centers]


func can_place_room(top_left: Vector2i, w: int, h: int):
	for x in range(w):
		for y in range(h):
			if (top_left + Vector2i(x,y)) in occupied:
				return false
	return true
