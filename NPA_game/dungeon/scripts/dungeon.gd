extends Node2D

# References
@onready var tile_map_layer: TileMapLayer = $TileMapLayer

# Classes
var poisson = PoissonDiscSampling.new()
var room_generator = RoomGenerator.new()

# enums & consts
enum room {
	MIN_WIDTH = 3,
	MAX_WIDTH = 6,
	MIN_HEIGHT = 3,
	MAX_HEIGHT = 7,
}
enum gen {
	PADDING = 1,
	WIDTH = 60,
	HEIGHT = 60,
	K = 30,
	TILESIZE = 32,
	DENSITY = 6 # Lower value = higher density. Value = distance between rooms
}


func _ready() -> void:
	if not tile_map_layer:
		push_error("TileMapLayer node not found!")
		return
	
	if not tile_map_layer.tile_set:
		push_error("TileMap has no TileSet assigned! Please assign a TileSet.")
		return
	
	var region_size = Vector2(gen.TILESIZE * gen.WIDTH, gen.TILESIZE * gen.HEIGHT)
	var radius = gen.TILESIZE * gen.DENSITY + gen.PADDING
	var points = poisson.generate_points(radius, region_size, gen.K)
	
	var occupied: Dictionary = room_generator.generate_rooms(points, room, gen)


	for tile in occupied.keys():
		tile_map_layer.set_cell(tile, 1, Vector2i(0, 0))

	# Creates tile at position of points
	print(points)
	var tile_size = Vector2i(gen.TILESIZE, gen.TILESIZE)
	for point in points:
		var tile_coord = Vector2i(
			int(point.x / tile_size.x),
			int(point.y / tile_size.y)
		)
		if tile_coord.x >= 0 and tile_coord.x < gen.WIDTH and tile_coord.y >= 0 and tile_coord.y < gen.HEIGHT:
			tile_map_layer.set_cell(tile_coord, 0, Vector2i(0, 0))
