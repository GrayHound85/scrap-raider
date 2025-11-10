extends Node2D

@export var workstation_name: String = "CHANGE ME"
@export var upgrades: Dictionary

func _ready() -> void:
	var upgrade_num = 0
	for i in upgrades:
		var value = upgrades[i]
		if i is not PackedScene:
			push_error("%s Upgrade %d material is not PackedScene" % [workstation_name,upgrade_num]) 
		if value is not int:
			push_error("%s Upgrade %d does not have valid material quantity" % [workstation_name, upgrade_num])
		upgrade_num += 1
