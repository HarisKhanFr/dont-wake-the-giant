extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	position.x = clamp(position.x, 0.0, 1128.0)
	position.y = clamp(position.y, 0.0, 624.0)
