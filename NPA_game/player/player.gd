extends CharacterBody2D

@export var speed = 5000

func get_input(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	#print(input_direction)
	velocity = input_direction * speed * delta
	rotation_degrees = input_direction.x * 90 + input_direction.y * 90
	

func _physics_process(delta: float) -> void:
	get_input(delta)
	move_and_slide()
