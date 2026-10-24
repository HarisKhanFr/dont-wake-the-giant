extends Node2D

@export var awakeFor: float = 1.0 #how long the giant is awake for
@export var sleepFor: float = 5.0 #sleep duration of the giant
var delivered_count: int = 0
var is_awake: bool = false #keeps track of giants sleep status

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
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
		$DroppedFood.global_position = $Player.global_position
		$DroppedFood.visible = true
		delivered_count += 1
		$UI/ScoreLabel.text = "Delivered: " + str(delivered_count) + "/3"
		print(delivered_count)
		
func _on_giant_timer_timeout() -> void:
	if is_awake:
		$Giant.color = Color.GREEN
		$GiantTimer.start(sleepFor)
		is_awake = false
	else:
		$Giant.color = Color.RED
		$GiantTimer.start(awakeFor)
		is_awake = true


func _on_item_body_entered(body: Node2D) -> void:
	if body == $Player:
		print("Picked up")
		$Player/HeldItem.visible = true
		$Item.queue_free()


func _on_mouse_hole_body_entered(body: Node2D) -> void:
	if body == $Player and $Player/HeldItem.visible == true:
		$UI/DropPrompt.visible = true


func _on_item_body_exited(body: Node2D) -> void:
	if body == $Player :
		$UI/DropPrompt.visible = false


func _on_mouse_hole_body_exited(body: Node2D) -> void:
	$UI/DropPrompt.visible = false # Replace with function body.
