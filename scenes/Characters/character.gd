extends CharacterBody2D

const GRAVITY := 600.0

@export var health : int
@export var damage : int
@export var jump_intensity : float
@export var speed : int

@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $CharacterSprite
@onready var hit_box := $HitBox

enum State {IDLE, WALK, ATTACK, TAKEOFF, JUMP, LAND}
var animation_map := {
	State.IDLE: "idle",
	State.WALK:"walk",
	State.TAKEOFF:"takeoff",
	State.JUMP:"jump",
	State.LAND:"landing",
	State.ATTACK:"attack",
}

var state = State.IDLE
var height := 0.0
var height_speed := 0.0

func _ready() -> void:
	hit_box.area_entered.connect(on_hit_box_area_entered)

func _process(delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animations()
	handle_air_time(delta)
	character_sprite.position = Vector2.UP * height
	move_and_slide()

func handle_movement() -> void:
	if can_move():
		if velocity.length() == 0:
			state = State.IDLE
		else:
			state = State.WALK

func handle_input() -> void:
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = direction * speed
	if can_attack() and Input.is_action_just_pressed("Attack"):
		state = State.ATTACK
	if can_jump() and Input.is_action_just_pressed("Jump"):
		state = State.TAKEOFF

func handle_animations() -> void:
	if animation_player.has_animation(animation_map[state]):
		animation_player.play(animation_map[state])
	
	if velocity.x > 0:
		character_sprite.flip_h = false
		hit_box.scale.x = 1
	elif velocity.x < 0:
		character_sprite.flip_h = true
		hit_box.scale.x = -1
		
func handle_air_time(delta : float) -> void:
	if state == State.JUMP:
		height += height_speed * delta
		if height < 0:
			height = 0
			state = State.LAND
		else:
			height_speed -= GRAVITY * delta


func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK 

func can_jump() -> bool:
	return state == State.IDLE or state == State.WALK

func can_move() -> bool:
	return state == State.IDLE or state == State.WALK

func on_action_completed() -> void:
	state = State.IDLE

func on_hit_box_area_entered(hurt_box : HurtBox) -> void:
	hurt_box.hit.emit(damage)
	print(hurt_box)

func on_takeoff_completed() -> void:
	state = State.JUMP
	height_speed = jump_intensity

func on_land_completed() -> void:
	state = State.IDLE
