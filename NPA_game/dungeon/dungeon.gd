extends Node2D

# References
@onready var tile_map_layer: TileMapLayer = $TileMapLayer

# Classes
var poisson = PoissonDiscSampling.new()

# enums & consts
enum room {WIDTH = 4, HEIGHT = 3,}
enum gen {PADDING = 1, WIDTH = 30, HEIGHT = 30, K = 30, TILESIZE = 32}


func _ready() -> void:
	if not tile_map_layer:
		push_error("TileMapLayer node not found!")
		return
	
	if not tile_map_layer.tile_set:
		push_error("TileMap has no TileSet assigned! Please assign a TileSet.")
		return
	
	var region_size = Vector2(gen.TILESIZE * gen.WIDTH, gen.TILESIZE * gen.HEIGHT)
	var radius = gen.TILESIZE * 1.5 + gen.PADDING
	var points = poisson.generate_points(radius, region_size, gen.K)
	
	print(points)
	
	var tile_size = Vector2i(gen.TILESIZE, gen.TILESIZE)
	for point in points:
		var tile_coord = Vector2i(
			int(point.x / tile_size.x),
			int(point.y / tile_size.y)
		)
		if tile_coord.x >= 0 and tile_coord.x < gen.WIDTH and tile_coord.y >= 0 and tile_coord.y < gen.HEIGHT:
			tile_map_layer.set_cell(tile_coord, 0, Vector2i(0, 0))
		
