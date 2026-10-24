extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@export var awakeFor: float = 1.0
@export var sleepFor: float = 5.0
var is_awake: bool = false
func _on_giant_timer_timeout() -> void:
	if is_awake:
		$Giant.color = Color.GREEN
		$GiantTimer.start(sleepFor)
		is_awake = false
	else:
		$Giant.color = Color.RED
		$GiantTimer.start(awakeFor)
		is_awake = true
