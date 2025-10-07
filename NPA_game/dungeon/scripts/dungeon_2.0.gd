extends Node2D

@onready var start_room: Room = $StartRoom
@export var tile_size: Vector2 = Vector2(32, 32)
@export var max_rooms: int = 10

@onready var rooms: Array = get_tree().get_nodes_in_group("rooms")

func _ready() -> void:
	print(start_room.get_random_valid_door())
	
	
