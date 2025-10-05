extends Node2D

@export var room_name: String

var door_points: Array[Vector2i]
var loot_points: Array[Vector2i]
var enemy_points: Array[Vector2i]

func _ready() -> void:
	var doors = $Doors
	var loot = $LootSpawns
	var enemies = $EnemySpawns
	
	doors.visible = false
	loot.visible = false
	enemies.visible = false
	
	for pos in doors.get_used_cells():
		door_points.append(pos)
	
	for pos in loot.get_used_cells():
		loot_points.append(pos)
		
	for pos in enemies.get_used_cells():
		enemy_points.append(pos)
