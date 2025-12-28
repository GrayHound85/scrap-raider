extends Resource
class_name InventoryFramework

var num_of_slots: int = -1
var next_availible_slot: int = 0
var inventory_data: Dictionary

# UI variables
var inventory_ui_created := false
var inventory_slot_grid: GridContainer # The grid container that holds all the UI slots

func _init(inventory_slots_data) -> void:
	inventory_data = inventory_slots_data

func add_item(item_resource: ItemResource, count: int = 1) -> void:
	if inventory_ui_created:
		var item_id = item_resource.item_id
		var item_aleady_has_slot := false
		
		for slot_key in inventory_data.keys():
			var slot = inventory_data[slot_key]
			
			if slot is InventoryItem:
				if slot.get_item_id() == item_id:
					item_aleady_has_slot = true
					if (slot.get_item_quantity() + count) <= item_resource.max_stack_size:
						inventory_data[slot_key].quantity += count
					elif inventory_data.size() >= num_of_slots:
						push_error("--- All slots filled, can't create a new slot ---")
					else:
						var difference = (inventory_data[slot_key].quantity + count) - item_resource.max_stack_size
						inventory_data[slot_key].quantity = item_resource.max_stack_size
						_create_new_slot(item_resource, difference)
			else:
				push_error("--- Item in inventory_slot dictionary is not of type InventoryItem ---")
		
		if item_aleady_has_slot == false:
			if inventory_data.size() >= 20:
				push_error("--- All slots filled, can't create a new slot ---")
			else:
				_create_new_slot(item_resource, count)
	else:
		push_error("-- You must first create the UI slots before you can add items to the inventory ---")
	
	_update_ui()



func _create_new_slot(item_resource: ItemResource, count: int) -> void:
	var new_item_slot := InventoryItem.new(item_resource, count)
	inventory_data[next_availible_slot] = new_item_slot
	next_availible_slot += 1


@warning_ignore("shadowed_variable")
func create_ui_slots(number_of_slots: int, slot_scene: PackedScene, target_container: GridContainer) -> void:
	for i in range(number_of_slots):
		var new_slot = slot_scene.instantiate()
		target_container.add_child(new_slot)
	num_of_slots = number_of_slots
	inventory_ui_created = true
	inventory_slot_grid = target_container


func _update_ui() -> void:
	for slot_key in inventory_data:
		var slot = inventory_data[slot_key]
		var ui_slot = inventory_slot_grid.get_child(slot_key)
		var slot_texture = ui_slot.get_node("CenterContainer/TextureButton")
		var slot_item_count_label = ui_slot.get_node("ItemCountLabel")
		slot_texture.texture_normal = slot.item_data.item_sprite
		slot_item_count_label.visible = true
		slot_item_count_label.text = str(slot.quantity)
		
		
