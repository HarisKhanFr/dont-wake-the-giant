extends Node2D

@export var warning_time: float = 0.8
@export var awakeFor: float = 2.5 #how long the giant is awake for
@export var sleepFor: float = 6.0 #sleep duration of the giant
var dropped_food_scene: PackedScene = preload("res://dropped_food.tscn")
var item_scene: PackedScene = preload("res://item.tscn")
var delivered_count: int = 0
var is_awake: bool = false #keeps track of giants sleep status
@onready var giant_start_position: Vector2 = $Giant.position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spawn_size = $ItemSpawnArea/CollisionShape2D.shape.size
	var spawn_center = $ItemSpawnArea/CollisionShape2D.global_position
	var left_edge = spawn_center.x - spawn_size.x / 2 + 20
	var right_edge = spawn_center.x + spawn_size.x / 2 - 20
	var top_edge = spawn_center.y - spawn_size.y / 2 + 20
	var bottom_edge = spawn_center.y + spawn_size.y / 2 - 20
	for i in range(3):
		var new_item = item_scene.instantiate()
		$SpawnedItems.add_child(new_item)
		var random_x = randf_range(left_edge, right_edge)
		var random_y = randf_range(top_edge, bottom_edge)
		new_item.global_position = Vector2(random_x, random_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	var timer_is_running = not $GiantTimer.is_stopped()
	var giant_is_sleeping = not is_awake
	var almost_awake = $GiantTimer.time_left <= warning_time
	if timer_is_running and giant_is_sleeping and almost_awake:
		var shake_x = randf_range(-5.0, 5.0)
		var shake_y = randf_range(-5.0, 5.0)
		$Giant.position = giant_start_position + Vector2(shake_x, shake_y)
	else:
		$Giant.position = giant_start_position
	
func _pauseGame() -> void:
	$GiantTimer.stop()
	$Player.set_physics_process(false)
	
func _restartGame() -> void:
	$GiantTimer.start()
	$Player.set_physics_process(true)
	
func _physics_process(float) -> void:
	if is_awake and int($Player.get_real_velocity().length()) != 0:
		$UI/GameOverLabel.visible = true
		_pauseGame()
		
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		_restartGame()
	
	if Input.is_action_just_pressed("drop") and $UI/DropPrompt.visible:
		$Player/HeldItem.visible = false
		$UI/DropPrompt.visible = false
		delivered_count += 1
		var new_food = dropped_food_scene.instantiate()
		$DeliveredItems.add_child(new_food)
		new_food.global_position = $Player.global_position
		$UI/ScoreLabel.text = "Delivered: " + str(delivered_count) + "/3"
		if delivered_count == 3:
			$UI/WinLabel.visible = true
			_pauseGame()
			if Input.is_action_just_pressed("restart"):
				get_tree().reload_current_scene()
				_restartGame()
				
func _on_giant_timer_timeout() -> void:
	if is_awake:
		$Giant.color = Color.GREEN
		$GiantTimer.start(sleepFor)
		is_awake = false
		$Giant/LeftEye.size.y = 5
		$Giant/RightEye.size.y = 5
	else:
		$Giant.color = Color.RED
		$GiantTimer.start(awakeFor)
		is_awake = true
		$Giant/LeftEye.size.y = 25
		$Giant/RightEye.size.y = 25

func _on_mouse_hole_body_entered(body: Node2D) -> void:
	if body == $Player and $Player/HeldItem.visible == true:
		$UI/DropPrompt.visible = true

func _on_mouse_hole_body_exited(body: Node2D) -> void:
	$UI/DropPrompt.visible = false # Replace with function body.


func _on_giant_touch_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	if body == $Player and not is_awake:
		$GiantTimer.start(warning_time)
