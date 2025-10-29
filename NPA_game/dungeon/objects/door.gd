extends StaticBody2D

@onready var door_collision: CollisionShape2D = $CollisionShape2D


var door_id := -2


func open_door():
	print(door_id)
	if door_collision:
		door_collision.disabled = true
		print("DKFJDFKJD")

func set_door_id(id: int):
	door_id = id


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.has_method("set_key_id"):
		return
	if body.key_id == door_id:
		open_door()
	else:
		print("Door locked, get correct key")
