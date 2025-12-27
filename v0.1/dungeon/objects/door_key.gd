extends Node2D

@export var key_id := 0

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("set_key_id"):
		body.set_key_id(key_id)
		queue_free()
