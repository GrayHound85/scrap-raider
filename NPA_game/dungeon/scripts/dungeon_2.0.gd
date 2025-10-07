extends Node2D

@onready var start_room: Room = $StartRoom
@export var tile_size: Vector2 = Vector2(32, 32)

@export var rooms: Array[PackedScene] 
@export var corridors: Array[PackedScene]
@onready var rooms_container: Node2D = $Rooms
@onready var corridors_container: Node2D = $Corridors

enum gen {
	MAX_ROOMS = 1,
	CORRIDOR_LENGTH = 3
}

var offset := Vector2.ZERO

func _ready() -> void:
	if rooms and corridors:
		var door = start_room.get_random_valid_door()
		var corridor = corridors.pick_random()
		for i in range(gen.MAX_ROOMS):
			build_corridor(door, corridor)
			var room = rooms.pick_random().instantiate()
			room.position = offset * tile_size
			rooms_container.add_child(room)
			door = room.get_random_valid_door()
			
			
			
	else:
		print("Rooms and or corridors don't exist")
		

func build_corridor(door1: Dictionary, corridor, door2: Dictionary = {Vector2i(-9999, -9999): Vector2i(0, 0)}):
	var d1_point = door1.keys()[0]
	var d1_direction = door1.values()[0]
	print(d1_point)
	print(d1_direction)
	if d1_direction.y == 0:
		print("Horrizontal corridor")
		for i in range(gen.CORRIDOR_LENGTH):
			var c = corridor.instantiate()
			c.position = Vector2(d1_point.x + (i * d1_direction.x), d1_point.y) * tile_size
			corridors_container.add_child(c)
			offset = Vector2(d1_point.x + (i * d1_direction.x), d1_point.y)
	if d1_direction.x == 0:
		print("Vertical corridor")
		for i in range(gen.CORRIDOR_LENGTH):
			var c = corridor.instantiate()
			c.position = Vector2(d1_point.x, d1_point.y + (i * d1_direction.y)) * tile_size
			corridors_container.add_child(c)
			offset = Vector2(d1_point.x, d1_point.y + (i * d1_direction.y))
	
