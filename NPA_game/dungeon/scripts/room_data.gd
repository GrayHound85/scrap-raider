extends Node2D
class_name Room

@export var room_name: String = "Unnamed"
@export var can_spawn_enemies: bool = true
@onready var floor: TileMapLayer = $Floor

var door_points: Array[Vector2i]
var loot_points: Array[Vector2i]
var enemy_points: Array[Vector2i]

var used_doors: Array[Vector2i]
const INVALID_DOOR := Vector2i(-9999, -9999)

func _ready() -> void:
	var doors = $Doors
	var loot = $LootSpawns
	var enemies = $EnemySpawns
	
	for pos in doors.get_used_cells():
		door_points.append(pos)
	
	for pos in loot.get_used_cells():
		loot_points.append(pos)
		
	for pos in enemies.get_used_cells():
		enemy_points.append(pos)
	
	hide_markers()


func hide_markers():
	$Doors.visible = false
	$LootSpawns.visible = false
	$EnemySpawns.visible = false


func get_random_valid_door() -> Dictionary:
	var options = []
	var picked := {}
	var direction := Vector2i(0, 0)
	for d in door_points:
		if not used_doors.has(d):
			options.append(d)
	
	if options.size() > 0:
		var door_pos = options.pick_random()
		if (door_pos.x + 1) in floor.get_used_cells():
			direction = Vector2i(1, 0)
		elif (door_pos.x - 1) in floor.get_used_cells():
			direction = Vector2i(-1, 0)
		elif (door_pos.y + 1) in floor.get_used_cells():
			direction = Vector2i(0, 1)
		else:
			direction = Vector2i(0, -1)
		
		picked[door_pos] = direction
	else:
		picked[INVALID_DOOR] = direction
		
	return picked
