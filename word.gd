extends Node2D

@onready var player = $Player
@onready var camera = $Camera


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.position.y = 32
	camera.position.x = 50
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.position.x > camera.position.x:
		camera.position.x = player.position.x
