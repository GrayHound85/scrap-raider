extends CanvasLayer

@onready var grid_container: GridContainer = $MarginContainer/Panel/VBoxContainer/Grid/MarginContainer/GridContainer
@onready var inventory_slot = preload("res://HUDs/inventory/inventory_slot.tscn")

var num_of_slots: int = 20
var next_availible_slot: int = 0
var inventory: InventoryFramework

func _ready() -> void:
	inventory = InventoryFramework.new(GameData.inventory_slots)
	inventory.create_ui_slots(20, inventory_slot, grid_container)
	inventory.add_item(ItemsDatabase.items_by_name["Stone"], 10)
	inventory.add_item(ItemsDatabase.items_by_name["Scrap Metal"], 2)
	inventory.add_item(ItemsDatabase.items_by_name["Stone"], 15)
