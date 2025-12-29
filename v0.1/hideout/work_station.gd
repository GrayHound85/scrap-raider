extends Node2D
# Node references
@onready var workstation_sprite: Sprite2D = $Sprite2D
@onready var work_station_ui: CanvasLayer = $WorkStationUI
const WORKSTATION_UPGRADE_ITEM_SLOT = preload("uid://b23pxk0i8ok44")

# Exported vars
@export var workstation_name: String = "CHANGE ME"
@export var work_station_sprites: Array[Texture2D]
@export var upgrades: Dictionary

var current_level := 1

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
	
	# Set up the workstation UI
	var workstation_title = work_station_ui.get_node("Panel/MarginContainer/VBoxContainer/WorkstationTitle")
	workstation_title.text = workstation_name
	
	# Validate upgrades.
	for upgrade in upgrades.values():
		for item in upgrade.keys():
			if item not in ItemsDatabase.items_by_name.keys():
				push_error("--- Not valid upgrade enterd for %s ---" % [workstation_name])
	

func interact():
	#print("You have interacted with %s" % [workstation_name])
	work_station_ui.visible = true
	
	# Display upgrade requirements
	if current_level in upgrades.keys():
		var upgrade_requirements = work_station_ui.get_node("Panel/MarginContainer/VBoxContainer/UpgradeRequirements")
		for child in upgrade_requirements.get_children():
			child.queue_free()
		for item in upgrades[current_level]:
			var item_resource = ItemsDatabase.items_by_name[item]
			var item_display_frame = WORKSTATION_UPGRADE_ITEM_SLOT.instantiate()
			upgrade_requirements.add_child(item_display_frame)
			var item_display_texture = item_display_frame.get_node("Panel/CenterContainer/ItemIcon")
			var item_count_label = item_display_frame.get_node("HBoxContainer/ItemCountLabel")
			item_count_label.text = "0/%d" % [upgrades[current_level][item]]
			item_display_texture.texture = item_resource.item_sprite
		
	


func stop_interacting():
	work_station_ui.visible = false
