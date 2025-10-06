extends Node2D

@export var room_pool: Array[PackedScene]
@onready var start_room: Room = $StartRoom
@export var tile_size: Vector2 = Vector2(32, 32)
@export var max_rooms: int = 10

var rooms: Array[Room]

func _ready() -> void:
	pass
	
	
