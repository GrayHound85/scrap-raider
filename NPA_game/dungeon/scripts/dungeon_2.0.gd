extends Node2D

@onready var start_room: Room = $DungeonTerrain/StartRoom
@export var tile_size: Vector2 = Vector2(32, 32)

@export var rooms: Array[PackedScene] 
@export var corridors: Array[PackedScene]
@onready var rooms_container: Node2D = $DungeonTerrain/Rooms
@onready var corridors_container: Node2D = $DungeonTerrain/Corridors
@onready var corridor_walls: TileMapLayer = $DungeonTerrain/CorridorWalls
@onready var doors_containter: Node2D = $DungeonTerrain/Doors

const LEVEL_1_DOOR = preload("uid://dxqy1m43on1sa")

enum gen {
	MAX_ROOMS = 5,
	CORRIDOR_LENGTH = 3
}

var occupied_tiles := {}
var doors := {}
var door_key_id = 0


func _ready() -> void:
	var current_room: Room = start_room
	if rooms.is_empty() or corridors.is_empty():
		print("Rooms and/or corridors don't exist")
		return

	mark_room_as_occupied(current_room)

	# --- INITIAL DOOR FROM START ROOM ---
	var door_local_dict = current_room.get_random_valid_door()
	var door_local = door_local_dict.keys()[0]
	if door_local == Vector2i(-9999, -9999):
		print("Start room has no valid doors!")
		return
	var door_dir = door_local_dict.values()[0]

	var door_world := {}
	var door_world_pos: Vector2i = local_to_world_tile(current_room, door_local)
	door_world[door_world_pos] = door_dir

	var corridor_scene = corridors.pick_random()

	for i in range(gen.MAX_ROOMS):
		var valid_room_found = false
		var attempts := 0

		while not valid_room_found and attempts < 10:
			attempts += 1

			# CORRIDOR START AND END (fix: end is one tile PAST the corridor)
			var start_tile: Vector2i = door_world.keys()[0]
			var dir: Vector2i = door_world[start_tile]
			var corridor_end_world: Vector2i = start_tile + dir * (gen.CORRIDOR_LENGTH)

			# INSTANTIATE CANDIDATE ROOM
			var room = rooms.pick_random().instantiate()
			rooms_container.add_child(room)

			var connection_door: Dictionary = room.get_connecting_door(dir)
			var room_door_local: Vector2i = connection_door.keys()[0]
			if room_door_local == Vector2i(-9999, -9999):
				room.queue_free()
				if attempts == 9:
					var new_local = current_room.get_random_valid_door()
					var new_key = new_local.keys()[0]
					if new_key == Vector2i(-9999, -9999):
						print("No doors left in current room, stopping generation.")
						return
					var new_world_pos = local_to_world_tile(current_room, new_key)
					door_world.clear()
					door_world[new_world_pos] = new_local.values()[0]
				continue

			# POSITION ROOM SO DOORS TOUCH (no gaps)
			room.position = Vector2(corridor_end_world - room_door_local - dir) * tile_size

			if room_overlap(room):
				room.queue_free()
				if attempts == 9:
					var new_local = current_room.get_random_valid_door()
					var new_key = new_local.keys()[0]
					if new_key == Vector2i(-9999, -9999):
						print("No doors left in current room, stopping generation.")
						return
					var new_world_pos = local_to_world_tile(current_room, new_key)
					door_world.clear()
					door_world[new_world_pos] = new_local.values()[0]
					attempts = 0
				continue

			# SUCCESSFUL PLACEMENT
			mark_room_as_occupied(room)
			build_corridor(door_world, corridor_scene)
			current_room = room
			valid_room_found = true

			# NEXT DOOR
			var next_local = current_room.get_random_valid_door()
			var next_local_key = next_local.keys()[0]
			if next_local_key == Vector2i(-9999, -9999):
				print("No valid door in newly placed room — stopping generation.")
				return
			var next_world_pos = local_to_world_tile(current_room, next_local_key)
			door_world.clear()
			door_world[next_world_pos] = next_local.values()[0]

		if not valid_room_found:
			print("Could not place a room for this step — stopping generation.")
			return


@warning_ignore("unused_parameter")
func build_corridor(door1: Dictionary, corridor, door2: Dictionary = {Vector2i(-9999, -9999): Vector2i(0, 0)}) -> void:
	#var offset: Vector2	
	var d1_point = door1.keys()[0]
	var d1_direction = door1.values()[0]
	var door_rotation = 0
	
	#print(d1_point)
	#print(d1_direction)
	for i in range(gen.CORRIDOR_LENGTH):
		var c = corridor.instantiate()
		var corridor_pos = d1_point + d1_direction * i
		c.position = Vector2(corridor_pos) * tile_size
		if i != 0 and i != (gen.CORRIDOR_LENGTH - 1):
			var all_surrounding = corridor_walls.get_surrounding_cells(corridor_pos)

			if d1_direction == Vector2i(-1, 0) or d1_direction == Vector2i(1,0):
				#print("X")
				#print(all_surrounding[1], all_surrounding[3])
				door_rotation = PI/2
				corridor_walls.set_cell(all_surrounding[1], 0, Vector2i(0,0), 2)
				corridor_walls.set_cell(all_surrounding[3], 0, Vector2i(0,0), 1)
				#tilemap.set_cell(wall_cells[1], 0, Vector2i(0,0), 2)
			if d1_direction == Vector2i(0, -1) or d1_direction == Vector2i(0,1):
				#print("y")
				#print(all_surrounding[0], all_surrounding[2])
				corridor_walls.set_cell(all_surrounding[0], 0, Vector2i(0,0), 3)
				corridor_walls.set_cell(all_surrounding[2], 0, Vector2i(0,0))
			
		# Build doors
		if i == roundi(gen.CORRIDOR_LENGTH/2):
			var door = LEVEL_1_DOOR.instantiate()
			doors[door] = door_key_id
			door.door_id = door_key_id
			door_key_id += 1
			doors_containter.add_child(door)
			door.position = Vector2(corridor_pos) * tile_size
			door.rotation = door_rotation
			
		corridors_container.add_child(c)


func room_overlap(room: Room) -> bool:
	for cell in room.floor.get_used_cells() + room.walls.get_used_cells():
		var world_pos: Vector2i = local_to_world_tile(room, cell)
		if occupied_tiles.has(world_pos):
			return true
	return false


func local_to_world_tile(room: Room, local_cell: Vector2i) -> Vector2i:
	var tile_world_pos = room.position / tile_size + Vector2(local_cell)
	return Vector2i(tile_world_pos)
	

func mark_room_as_occupied(room: Room) -> void:
	for cell in room.floor.get_used_cells():
		var world_pos: Vector2i = local_to_world_tile(room, cell)
		occupied_tiles[world_pos] = true
		
	for cell in room.walls.get_used_cells():
		var world_pos: Vector2i = local_to_world_tile(room, cell)
		occupied_tiles[world_pos] = true


func build_test_corridor(door1: Dictionary):
	var d1_point = door1.keys()[0]
	var d1_direction = door1.values()[0]
	var corridor_end = d1_point + d1_direction * (gen.CORRIDOR_LENGTH - 1)
	var offset = Vector2(corridor_end)
	return offset
