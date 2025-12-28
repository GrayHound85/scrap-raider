extends Node
#class_name ItemDatabase

const ITEMS_FOLDER := "res://item_system/items/"

var items_by_id: Dictionary[int, ItemResource]
var items_by_name: Dictionary[String, ItemResource]

func _ready() -> void:
	load_all_items()


func load_all_items() -> void:
	items_by_id.clear()
	items_by_name.clear()
	
	var dir := DirAccess.open(ITEMS_FOLDER)
	if dir == null:
		push_error("--- Items folder not found ---")
		return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	var next_id := 0

	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var path := ITEMS_FOLDER + file_name
			var item: ItemResource = load(path)

			if item == null:
				push_warning("Failed to load item: " + path)
			else:
				item.item_id = next_id
				items_by_id[next_id] = item
				items_by_name[item.item_name] = item
				next_id += 1

		file_name = dir.get_next()
	
	
