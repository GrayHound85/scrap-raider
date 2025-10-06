extends CanvasLayer

@onready var tile_location_label: Label = $Label
@onready var camera = get_viewport().get_camera_2d()
@onready var tile_map: TileMapLayer = get_tree().get_root().find_child("TileMapLayer", true, false)


var view_to_world

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var mouse_pos_screen: Vector2 = get_viewport().get_mouse_position()
	var world_pos = camera.get_canvas_transform().affine_inverse() * mouse_pos_screen
	var local_pos: Vector2 = tile_map.to_local(world_pos)
	var tile_coord: Vector2i = tile_map.local_to_map(local_pos)
		
	tile_location_label.text = "Tile: %s" % str(tile_coord)
	
