extends Node2D

@onready var player = $Actores/Player
@onready var camera = $Camera


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.position = player.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	camera.position = player.position
	#if player.position.x > camera.position.x:
		#camera.position.x = player.position.x
