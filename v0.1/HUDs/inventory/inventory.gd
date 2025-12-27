extends CanvasLayer

@onready var grid_container: GridContainer = $MarginContainer/Panel/VBoxContainer/Grid/MarginContainer/GridContainer
@onready var inventory_slot = preload("res://HUDs/inventory/inventory_slot.tscn")

var num_of_slots: int = 20
var next_availible_slot: int = 0

func _ready() -> void:
	for i in range(num_of_slots):
		var new_slot = inventory_slot.instantiate()
		grid_container.add_child(new_slot)


func add_item(item_resource: ItemResource, count: int = 1) -> void:
	var item_id = item_resource.item_id
	var item_aleady_has_slot := false
	
	for slot_key in GameData.inventory_slots.keys():
		var slot = GameData.inventory_slots[slot_key]
		
		if slot is InventoryItem:
			if slot.get_item_id() == item_id:
				item_aleady_has_slot = true
				if (slot.get_item_quantity() + count) <= item_resource.max_stack_size:
					GameData.inventory_slots[slot_key].quantity += count
				elif GameData.inventory_slots.size() <= num_of_slots:
					print("--- All slots filled, can't create a new slot ---")
				else:
					var difference = (GameData.inventory_slots[slot_key].quantity + count) - item_resource.max_stack_size
					GameData.inventory_slots[slot_key].quantity = item_resource.max_stack_size
					create_new_slot(item_resource, difference)
		else:
			print("--- Item in inventory_slot dictionary is not of type InventoryItem ---")
	
	if !item_aleady_has_slot:
		if GameData.inventory_slots.size() <= 20:
			print("--- All slots filled, can't create a new slot ---")
		else:
			create_new_slot(item_resource, count)


func create_new_slot(item_resource: ItemResource, count: int) -> void:
	var new_item_slot := InventoryItem.new(item_resource, count)
	GameData.inventory_slots[next_availible_slot] = new_item_slot
