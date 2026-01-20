extends CharacterBody2D

@export var health : int
@export var speed : int
@export var Damage : int

@onready var animation_player = $AnimationPlayer
@onready var character_sprite = $CharacterSprite

enum State {IDLE, WALK, ATTACK}
var state = State.IDLE

func _process(_delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animations()
	move_and_slide()

func handle_movement() -> void:
	
	if can_move():
		if velocity.length() == 0:
			state = State.IDLE
		else:
			state = State.WALK
	else:
		velocity = Vector2.ZERO

func handle_input() -> void:
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = direction * speed
	if can_attack() and Input.is_action_just_pressed("Attack"):
		state = State.ATTACK

func handle_animations() -> void:
	if state == State.IDLE:
		animation_player.play("idle")
	elif state == State.WALK:
		animation_player.play("walk")
	elif state == State.ATTACK:
		animation_player.play("attack")
	
	if velocity.x > 0:
		character_sprite.flip_h = false
	elif velocity.x < 0:
		character_sprite.flip_h = true
	
func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK 

func can_move() -> bool:
	return state == State.IDLE or state == State.WALK

func on_action_completed() -> void:
	state = State.IDLE
