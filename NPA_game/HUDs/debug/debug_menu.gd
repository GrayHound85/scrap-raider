extends CanvasLayer


@onready var tile_location_label: Label = $MarginContainer/VBoxContainer/TileCoordLabel
@onready var camera = get_viewport().get_camera_2d()
@onready var tile_map: TileMapLayer = get_tree().get_root().find_child("TileMapLayer", true, false)
@onready var fps_label: Label = $MarginContainer/VBoxContainer/FPSLabel
@onready var advanced_menu: Panel = $MarginContainer/VBoxContainer/Control
@onready var advanced_toggle: CheckButton = $MarginContainer/VBoxContainer/AdvancedToggle

# Advanced options
@onready var toggle_door_points: CheckButton = $MarginContainer/VBoxContainer/Control/MarginContainer/VBoxContainer/ToggleDoorPoints
@onready var toggle_loot_spawns: CheckButton = $MarginContainer/VBoxContainer/Control/MarginContainer/VBoxContainer/ToggleLootSpawns
@onready var toggle_enemy_spawns: CheckButton = $MarginContainer/VBoxContainer/Control/MarginContainer/VBoxContainer/ToggleEnemySpawns


var view_to_world

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# FPS counter
	fps_label.text = "FPS: %s" % str(Engine.get_frames_per_second())
	

	# Display tile coord
	var mouse_pos_screen: Vector2 = get_viewport().get_mouse_position()
	var world_pos = camera.get_canvas_transform().affine_inverse() * mouse_pos_screen
	var local_pos: Vector2 = tile_map.to_local(world_pos)
	var tile_coord: Vector2i = tile_map.local_to_map(local_pos)
		
	tile_location_label.text = "Tile: %s" % str(tile_coord)
	

# ------------------------------------------------------------------------ #
#                               Advanced options
# ------------------------------------------------------------------------ #
func _on_advanced_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		advanced_menu.visible = true
	if not toggled_on:
		advanced_menu.visible = false


func get_rooms():
	var rooms = get_tree().get_nodes_in_group("rooms")

func _on_toggle_door_points_toggled(toggled_on: bool) -> void:
	var rooms = get_rooms()
	for r in rooms: 
		if r is Room:
			r.toggle_door_points()


func _on_toggle_loot_spawns_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.


func _on_toggle_enemy_spawns_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
