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
	
	var resion_size = Vector2(gen.TILESIZE * gen.WIDTH, gen.TILESIZE * gen.HEIGHT)
	var radius = gen.TILESIZE * 1.5 + gen.PADDING
	var points = poisson.generate_points(radius, resion_size, gen.K)
	
	var tile_size = Vector2i(gen.TILESIZE, gen.TILESIZE)
	for point in points:
		var tile_coord = Vector2i(
			int(round(point.x / tile_size.x)),
			int(round(point.y / tile_size.y))
		)
		
		tile_map_layer.set_cell(tile_coord, 0)
		
