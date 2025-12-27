extends StaticBody2D

@onready var door_collision: CollisionShape2D = $DoorCollision
@onready var sprite: Sprite2D = $Sprite2D
@onready var lock_sprite: Sprite2D = $LockSprite
@onready var lock_animator: AnimationPlayer = $LockSprite/AnimationPlayer


var door_id := -2
var is_unlocked := false
var is_open := false

func open_door():
	print(door_id)
	if not is_unlocked:
		door_collision.set_deferred("disabled", true)
		print("Door unlocked")
		lock_sprite.visible = false
		is_unlocked = true
	if is_unlocked:
		sprite.rotation = sprite.rotation - PI/2
		sprite.position = sprite.position - Vector2(16,16)
		is_open = true

func set_door_id(id: int):
	door_id = id


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.has_method("set_key_id"):
		return
	if body.key_id == door_id:
		open_door()
	else:
		print("Door locked, get correct key")
		lock_animator.play("shake")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if not body.has_method("set_key_id"):
		return
	if is_open:
		sprite.rotation = sprite.rotation + PI/2
		sprite.position = sprite.position + Vector2(16,16)
