extends Node

class_name PoissonDiscSampling

func generate_points(radius: float, region_size: Vector2i, max_samples: int = 30) -> Array:
	var points := []
	var grid := []
	var cell_size = radius / sqrt(2.0)
	var grid_width = int(ceil(region_size.x / cell_size))
	var grid_height = int(ceil(region_size.y / cell_size))
	
	for x in range(grid_width):
		grid.append([])
		for y in range(grid_height):
			grid[x].append(null)
	
	var active := []
	
	var first_point = Vector2(randf() * region_size.x, randf() * region_size.y)
	var first_cell = Vector2i(int(first_point.x / cell_size), int(first_point.y / cell_size))
	points.append(first_point)
	grid[first_cell.x][first_cell.y] = first_point
	active.append(first_point)
	
	while active.size() > 0:
		var idx = randi() % active.size()
		var point = active[idx]
		var found = false
		
		for i in range(max_samples):
			var angle = randf() * TAU 
			var r = radius + randf() * radius
			var new_point = point + Vector2(cos(angle), sin(angle)) * r
			
			if new_point.x >= 0 and new_point.x < region_size.x and new_point.y >= 0 and new_point.y < region_size.y:
				var cell = Vector2i(int(new_point.x / cell_size), int(new_point.y / cell_size))
				
				if cell.x >= 0 and cell.x < grid_width and cell.y >= 0 and cell.y < grid_height:
					var valid = true
					for dx in range(-2, 3):
						for dy in range(-2, 3):
							var neighbour_x = cell.x + dx
							var neighbour_y = cell.y + dy
							if neighbour_x >= 0 and neighbour_x < grid_width and neighbour_y >= 0 and neighbour_y < grid_height:
								var neighbour = grid[neighbour_x][neighbour_y]
								if neighbour != null and new_point.distance_to(neighbour) < radius:
									valid = false
									break
						if not valid:
							break
					
					if valid:
						points.append(new_point)
						grid[cell.x][cell.y] = new_point
						active.append(new_point)
						found = true
						break
					
		if not found:
			active.remove_at(idx)
							
	return points

"""
func _ready() -> void:
	var points = generate_points(10.0, Vector2(100,100), 30)
	for point in points:
		print("point: ", point)
"""
