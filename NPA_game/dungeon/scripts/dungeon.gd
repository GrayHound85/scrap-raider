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
	generate_dungeon()

func generate_dungeon():
	tile_map_layer.clear()
	
	if not tile_map_layer:
		push_error("TileMapLayer node not found!")
		return
	
	if not tile_map_layer.tile_set:
		push_error("TileMap has no TileSet assigned! Please assign a TileSet.")
		return
	
	var region_size = Vector2(gen.TILESIZE * gen.WIDTH, gen.TILESIZE * gen.HEIGHT)
	var radius = gen.TILESIZE * gen.DENSITY + gen.PADDING
	var points = poisson.generate_points(radius, region_size, gen.K)
	
	var rooms_data = room_generator.generate_rooms(points, room, gen)
	var occupied: Dictionary = rooms_data[0]
	var room_centers: Array = rooms_data[1]


	for tile in occupied.keys():
		tile_map_layer.set_cell(tile, 1, Vector2i(0, 0))
	
	display_points(points, 0)
	display_points(room_centers, 2)

func display_points(points, source_id):
	var tile_size = Vector2i(gen.TILESIZE, gen.TILESIZE)
	for point in points:
		var tile_coord = Vector2i(
			int(point.x / tile_size.x),
			int(point.y / tile_size.y)
		)
		if tile_coord.x >= 0 and tile_coord.x < gen.WIDTH and tile_coord.y >= 0 and tile_coord.y < gen.HEIGHT:
			tile_map_layer.set_cell(tile_coord, source_id, Vector2i(0, 0))


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_menu"):
		generate_dungeon()
