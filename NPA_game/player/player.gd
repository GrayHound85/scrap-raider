extends CharacterBody2D

@export var speed = 100
@onready var ani: AnimatedSprite2D = $AnimatedSprite2D

var key_id := -1

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	#print(input_direction)
	if input_direction != Vector2.ZERO:
		rotation = input_direction.angle() + deg_to_rad(90)
		ani.play("walk")
	else:
		ani.play("idle")
		
	velocity = input_direction * speed
	
	

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

func set_key_id(id: int):
	key_id = id
	print("Player key set to: ", id)
