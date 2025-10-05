extends Node2D
class_name Room

@export var room_name: String = "Unnamed"
@export var can_spawn_enemies: bool = true

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


func get_random_free_door() -> Vector2i:
	var options = []
	for d in door_points:
		if not used_doors.has(d):
			options.append(d)
	return options.pick_random() if options.size() > 0 else INVALID_DOOR
