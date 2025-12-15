extends CharacterBody2D

@export var speed = 100
@onready var ani: AnimatedSprite2D = $AnimatedSprite2D
@onready var main_hud: CanvasLayer = $MainHUD

var key_id := -1
var focused_object = null
var can_move := true

func _input(event: InputEvent) -> void:
		
	if event.is_action_pressed("interact") and focused_object != null and can_move:
		focused_object.interact()
		can_move = false
		interact_label_visible(false)
		return

	if not can_move and (event.is_action_pressed("interact") or event.is_action_pressed("esc")):
		focused_object.stop_interacting()
		can_move = true
		interact_label_visible(true)
		return

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	#print(input_direction)
	if input_direction != Vector2.ZERO and can_move:
		rotation = input_direction.angle() + deg_to_rad(90)
		ani.play("walk")
	else:
		ani.play("idle")
	
	if can_move:
		velocity = input_direction * speed
	else:
		velocity = Vector2.ZERO
	
func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()

func set_key_id(id: int):
	key_id = id
	print("Player key set to: ", id)


func _on_area_2d_body_exited(body: Node2D) -> void:
	var root = body.get_parent()
	if root.is_in_group("interactable"):
		if root.has_method("interact") and root.has_method("stop_interacting"):
			focused_object = root
			interact_label_visible(false)
			focused_object = null


func _on_area_2d_body_entered(body: Node2D) -> void:
	var root = body.get_parent()
	if root.is_in_group("interactable"):
		if root.has_method("interact") and root.has_method("stop_interacting"):
			interact_label_visible(true)
			focused_object = root
			print("Can interact")

	
func interact_label_visible(state: bool):
	var interact_label = main_hud.get_child(1)
	if state == true:
		interact_label.visible = true
	elif state == false:
		interact_label.visible = false
