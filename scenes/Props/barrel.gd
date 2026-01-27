extends StaticBody2D

@onready var hurt_box := $HurtBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurt_box.hit.connect(on_hit.bind())

func on_hit(damage: int, _direction : Vector2) -> void:
	print(damage)
	queue_free()
