class_name  Character
extends CharacterBody2D

const GRAVITY := 600.0

@export var max_health : int
@export var current_health : int
@export var damage : int = 10
@export var jump_intensity : float = 100.0
@export var speed : int = 50
@export var knokback_intensity : float = 1
@export var knokdown_intensity : float = 1
@export var duration_grounded_ms : int = 300


@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $Visual
@onready var hit_boxes := $Visual/HitBoxes
@onready var hurt_box : HurtBox = $HurtBox

enum State {IDLE, WALK, ATTACK, TAKEOFF, JUMP, JUMP_KICK, LAND, HURT, FALL, GROUNDED}
var animation_map := {
	State.IDLE: "idle",
	State.WALK:"walk",
	State.TAKEOFF:"takeoff",
	State.JUMP:"jump",
	State.JUMP_KICK:"jump_kick",
	State.LAND:"land",
	State.ATTACK:"attack",
	State.HURT:"hurt",
	State.FALL:"fall",
	State.GROUNDED:"grounded",
}

var state = State.IDLE
var height := 0.0
var height_speed := 0.0
var time_grounded := Time.get_ticks_msec()

func _ready() -> void:
	current_health = max_health
	hurt_box.hit.connect(on_hit.bind())
	for hit_box in hit_boxes.get_children():
		hit_box.area_entered.connect(on_hit_box_area_entered.bind())

func _process(delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animations()
	handle_air_time(delta)
	handle_grounded_time()
	character_sprite.position = Vector2.UP * height
	move_and_slide()

func enable_hitbox(hitbox_name: String):
	hit_boxes.get_node(hitbox_name).monitoring = true

func disable_hitbox(hitbox_name: String):
	hit_boxes.get_node(hitbox_name).monitoring = false


func handle_movement() -> void:
	if can_move():
		if velocity.length() == 0:
			state = State.IDLE
		else:
			state = State.WALK

func handle_input() -> void:
	pass
	


func handle_animations() -> void:
	if animation_player.has_animation(animation_map[state]):
		animation_player.play(animation_map[state])
	
	if velocity.x > 0:
		character_sprite.scale.x = 1
	elif velocity.x < 0:
		character_sprite.scale.x = -1


func handle_grounded_time() -> void:
	if state == State.GROUNDED and (Time.get_ticks_msec() - time_grounded > duration_grounded_ms):
		state = State.LAND

func handle_air_time(delta : float) -> void:
	if [State.JUMP,State.JUMP_KICK,State.FALL].has(state):
		height += height_speed * delta
		if height <= 0:
			height = 0
			if state == State.FALL:
				state = State.GROUNDED
				time_grounded = Time.get_ticks_msec()
			else:
				state = State.LAND
			velocity = Vector2.ZERO
		else:
			height_speed -= GRAVITY * delta


func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK or state == State.JUMP

func can_jump() -> bool:
	return state == State.IDLE or state == State.WALK

func can_move() -> bool:
	return state == State.IDLE or state == State.WALK

func on_action_completed() -> void:
	state = State.IDLE
	

func on_hit_box_area_entered(collisioned_hurt_box : HurtBox) -> void:
	var hit_type := HurtBox.HitType.NORMAL
	var direccion := Vector2.LEFT if collisioned_hurt_box.global_position.x < global_position.x else Vector2.RIGHT
	if state == State.JUMP_KICK:
		hit_type = HurtBox.HitType.KNOCKDOWN
	collisioned_hurt_box.hit.emit(damage, direccion, hit_type)
	print(hurt_box)

func on_hit(damage_recived: int, direction : Vector2, hit_type: HurtBox.HitType) -> void:
	current_health -= damage_recived
	if current_health <= 0 or hit_type == HurtBox.HitType.KNOCKDOWN:
		state = State.FALL
		height_speed = knokdown_intensity
	else:
		state = State.HURT
	velocity = direction * knokback_intensity
	
	print("Damage:",damage_recived,": ",current_health,"/",max_health)

func on_takeoff_completed() -> void:
	state = State.JUMP
	height_speed = jump_intensity

func on_land_completed() -> void:
	state = State.IDLE
