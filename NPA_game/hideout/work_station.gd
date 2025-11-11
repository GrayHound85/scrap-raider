extends Node2D
# Node references
@onready var workstation_sprite: Sprite2D = $Sprite2D

# Exported vars
@export var workstation_name: String = "CHANGE ME"
@export var work_station_sprites: Array[Texture2D]
@export var upgrades: Dictionary

func _ready() -> void:
	
	# Checks all materials and quantities are valid
	var upgrade_num = 0
	for i in upgrades:
		var value = upgrades[i]
		if i is not PackedScene:
			push_error("%s Upgrade %d material is not PackedScene" % [workstation_name,upgrade_num]) 
		if value is not int:
			push_error("%s Upgrade %d does not have valid material quantity" % [workstation_name, upgrade_num])
		upgrade_num += 1
	
	# Sets the initail level 1 sprite for the station
	if len(work_station_sprites) != 0:
		workstation_sprite.texture = work_station_sprites[0]
		
	
