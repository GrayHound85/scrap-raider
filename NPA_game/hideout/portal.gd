extends Node2D

# References
@onready var locked_portal_collision: CollisionShape2D = $LockedPortal/LockedPortalCollision

# Exports
@export var teleport_location: PackedScene
@export var portal_animation: SpriteFrames
@export var is_locked: bool = true

func _ready() -> void:
	if not is_locked:
		locked_portal_collision.disabled = true


func _on_teleport_area_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_packed(teleport_location)
