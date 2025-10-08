extends Node2D
class_name Room

@export var room_name: String = "Unnamed"
@export var can_spawn_enemies: bool = true
@onready var floor: TileMapLayer = $Floor

@onready var doors = $Doors
@onready var loot = $LootSpawns
@onready var enemies = $EnemySpawns

var door_points: Array[Vector2i]
var loot_points: Array[Vector2i]
var enemy_points: Array[Vector2i]

var used_doors: Array[Vector2i]
const INVALID_DOOR := Vector2i(-9999, -9999)

func _ready() -> void:
	add_to_group("rooms")
	
	for pos in doors.get_used_cells():
		door_points.append(pos)
	
	for pos in loot.get_used_cells():
		loot_points.append(pos)
	
	for pos in enemies.get_used_cells():
		enemy_points.append(pos)
	
	hide_markers()

# Debug overlay toggle ----------
func toggle_door_points():
	if doors.visible == true:
		doors.visible = false
	else:
		doors.visible = true
	
func toggle_loot_spawns():
	if loot.visible == true:
		loot.visible = false
	else:
		loot.visible = true

func toggle_enemy_spawns():
	if enemies.visible == true:
		enemies.visible = false
	else:
		enemies.visible = true

# -------------------------------
func hide_markers():
	doors.visible = false
	loot.visible = false
	enemies.visible = false


func get_connecting_door(connecting_direction: Vector2i) -> Dictionary:
	var options: Array[Vector2i] = []
	var picked: Dictionary = {}
	var direction: Vector2i = Vector2i(0, 0)
	#print("door points: " + str(door_points))

	for d in door_points:
		if not used_doors.has(d):
			options.append(d)

	if options.size() > 0:
		for door_pos in options:
			#print("door pos: " + str(door_pos))
			if Vector2i(door_pos.x + 1, door_pos.y) in floor.get_used_cells():
				direction = Vector2i(-1, 0)
			elif Vector2i(door_pos.x - 1, door_pos.y) in floor.get_used_cells():
				direction = Vector2i(1, 0)
			elif Vector2i(door_pos.x, door_pos.y - 1) in floor.get_used_cells():
				direction = Vector2i(0, 1)
			elif Vector2i(door_pos.x, door_pos.y + 1) in floor.get_used_cells():
				direction = Vector2i(0, -1)
			else:
				direction = Vector2i(0, 0)

			if direction == -connecting_direction:
				picked[door_pos] = direction
				used_doors.append(door_pos)
				break

		if not picked:
			picked[INVALID_DOOR] = Vector2i(0, 0)
	else:
		picked[INVALID_DOOR] = Vector2i(0, 0)

	return picked


func get_random_valid_door() -> Dictionary:
	var options = []
	var picked := {}
	var direction := Vector2i(0, 0)
	for d in door_points:
		if not used_doors.has(d):
			options.append(d)
	
	if options.size() > 0:
		var door_pos = options.pick_random()
		used_doors.append(door_pos)
		if Vector2i(door_pos.x + 1, door_pos.y) in floor.get_used_cells():
			direction = Vector2i(-1, 0)
		elif Vector2i(door_pos.x - 1, door_pos.y) in floor.get_used_cells():
			direction = Vector2i(1, 0)
		elif  Vector2i(door_pos.x, door_pos.y - 1) in floor.get_used_cells():
			direction = Vector2i(0, 1)
		elif  Vector2i(door_pos.x, door_pos.y + 1) in floor.get_used_cells():
			direction = Vector2i(0, -1)
		else:
			direction = INVALID_DOOR
		
		picked[door_pos] = direction
	else:
		picked[INVALID_DOOR] = direction
		
	return picked
