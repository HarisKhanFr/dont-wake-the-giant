extends Node2D

@export var awakeFor: float = 1.0 #how long the giant is awake for
@export var sleepFor: float = 5.0 #sleep duration of the giant
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

func _on_giant_timer_timeout() -> void:
	if is_awake:
		$Giant.color = Color.GREEN
		$GiantTimer.start(sleepFor)
		is_awake = false
	else:
		$Giant.color = Color.RED
		$GiantTimer.start(awakeFor)
		is_awake = true
