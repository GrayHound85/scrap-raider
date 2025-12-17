extends CanvasLayer

@onready var grid_container: GridContainer = $MarginContainer/Panel/VBoxContainer/Grid/MarginContainer/GridContainer
@onready var inventory_slot = preload("res://HUDs/inventory/inventory_slot.tscn")

var num_of_slots: int = 20

func _ready() -> void:
	for i in range(num_of_slots):
		var new_slot = inventory_slot.instantiate()
		grid_container.add_child(new_slot)

func add_item(item_resource: ItemResource, count: int = 1):
	var item_id = item_resource.item_id
	
	if GameData.inventory_slots.has(item_id):
		GameData.inventory_slots[item_id].quantity += count
	else:
		var new_slot = InventoryItem.new(item_resource, count)
		GameData.inventory_slots[item_id] = new_slot
