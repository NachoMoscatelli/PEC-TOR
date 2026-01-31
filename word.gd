extends Node2D

@onready var player = $Actors/Hector
@onready var camera = $Camera


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.position.x = player.position.x
	camera.position.y = player.position.y
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	camera.position.x = player.position.x
	camera.position.y = player.position.y - 40
	
	
	#if player.position.x > camera.position.x:
		#camera.position.x = player.position.x
