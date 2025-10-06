extends CanvasLayer

@onready var tile_location_label: Label = $Label
@onready var camera = get_viewport().get_camera_2d()

var view_to_world

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var world_pos = camera.to_global(get_viewport().get_mouse_position())
		print(world_pos)
		#print(get_viewport().get_mouse_position())
		#print(get_viewport().get_global_mouse_position())
	
