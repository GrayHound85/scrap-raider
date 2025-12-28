extends RefCounted
class_name InventoryItem

var item_data: ItemResource = null
var quantity: int = 0

func _init(item_resource: ItemResource, count: int) -> void:
	self.item_data = item_resource
	self.quantity = count
	
func is_empty() -> bool:
	return item_data == null or quantity <= 0

func get_item_name() -> String:
	if item_data != null:
		return item_data.item_name
	return "Empty slot"

func get_item_quantity() -> int:
	if item_data != null:
		return quantity
	return -1

func get_item_id() -> int:
	if item_data != null:
		return item_data.item_id
	return -1
