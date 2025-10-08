extends Node2D

@onready var start_room: Room = $StartRoom
@export var tile_size: Vector2 = Vector2(32, 32)

@export var rooms: Array[PackedScene] 
@export var corridors: Array[PackedScene]
@onready var rooms_container: Node2D = $Rooms
@onready var corridors_container: Node2D = $Corridors

enum gen {
	MAX_ROOMS = 6,
	CORRIDOR_LENGTH = 3
}


func _ready() -> void:
	if rooms and corridors:
		var door = start_room.get_random_valid_door()
		var corridor = corridors.pick_random()
		var corridor_dir = door.values()[0]
		
		for i in range(gen.MAX_ROOMS):
			var offset = build_corridor(door, corridor)
			var room = rooms.pick_random().instantiate()
			rooms_container.add_child(room)
			var connection_door: Dictionary = room.get_connecting_door(corridor_dir)
			print(connection_door)
			var room_door_pos: Vector2i = connection_door.keys()[0]
			
			room.position = (offset - Vector2(room_door_pos)) * tile_size

			door = room.get_random_valid_door()
			print("Next door pos local = " + str(door.keys()[0]))
			door[Vector2i(offset - Vector2(room_door_pos) + Vector2(door.keys()[0]))] = door.values()[0]
			door.erase(door.keys()[0])
			print("Next door pos global = " + str(door.keys()[0]))
			corridor_dir = door.values()[0]
			
			
			
	else:
		print("Rooms and or corridors don't exist")
		

func build_corridor(door1: Dictionary, corridor, door2: Dictionary = {Vector2i(-9999, -9999): Vector2i(0, 0)}):
	var offset: Vector2
	var d1_point = door1.keys()[0]
	var d1_direction = door1.values()[0]
	#print(d1_point)
	#print(d1_direction)
	for i in range(gen.CORRIDOR_LENGTH):
		var c = corridor.instantiate()
		var corridor_pos = d1_point + d1_direction * i
		c.position = Vector2(corridor_pos) * tile_size
		corridors_container.add_child(c)
	
	var corridor_end = d1_point + d1_direction * (gen.CORRIDOR_LENGTH - 1)
	offset = corridor_end
	print("offset = " + str(offset))
	return offset
	
