extends CharacterBody2D

@export var speed = 5000

func get_input(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed * delta


func _physics_process(delta: float) -> void:
	get_input(delta)
	move_and_slide()
