extends CharacterBody2D

@export var speed: int = 100
@onready var ani: AnimatedSprite2D = $AnimatedSprite2D
@onready var main_hud: CanvasLayer = $MainHUD
@onready var inventory: CanvasLayer = $Inventory

var key_id := -1
var focused_object = null
var is_interacting := false
var interaction_type: int = -1

enum interaction_code{
	NOT_INTERACTING = -1,
	INVENTORY = 0,
	WORKSTATION = 1
	
}

func _input(event: InputEvent) -> void:

	if event.is_action_pressed("interact") or event.is_action_pressed("esc"):
		if focused_object != null and is_interacting and interaction_type == interaction_code.WORKSTATION:
			focused_object.stop_interacting()
			is_interacting = false
			print("interaction stopped")
			interaction_type = interaction_code.NOT_INTERACTING
			interact_label_visible(true)
			return
		
		if focused_object != null and not is_interacting and interaction_type == interaction_code.NOT_INTERACTING:
			focused_object.interact()
			is_interacting = true
			print("interaction started")
			interaction_type = interaction_code.WORKSTATION
			interact_label_visible(false)
			return
			
	# Inventory toggle
	if event.is_action_pressed("tab"):
		if inventory.visible == false and is_interacting == false and interaction_type == interaction_code.NOT_INTERACTING:
			inventory.visible = true
			is_interacting = true
			interaction_type = interaction_code.INVENTORY
			
		elif inventory.visible == true and is_interacting == true and interaction_type == interaction_code.INVENTORY:
			inventory.visible = false
			is_interacting = false
			interaction_type = interaction_code.NOT_INTERACTING

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	#print(input_direction)
	if input_direction != Vector2.ZERO and not is_interacting:
		rotation = input_direction.angle() + deg_to_rad(90)
		ani.play("walk")
	else:
		ani.play("idle")
	
	if not is_interacting and interaction_type == interaction_code.NOT_INTERACTING:
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
			#print("Can interact")

	
func interact_label_visible(state: bool):
	var interact_label = main_hud.get_child(1)
	if state == true:
		interact_label.visible = true
	elif state == false:
		interact_label.visible = false
