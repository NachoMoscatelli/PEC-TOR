class_name BasicEnemy
extends Character

@export var player : Player
@export var duration_between_hits : int 
@export var duration_prep_hit : int

var time_since_last_hit = Time.get_ticks_msec()
var prepearing_hit = false
var time_since_prep_hit = Time.get_ticks_msec()
var player_slot : EnemySlot = null

func _ready() -> void:
	punch_combo = ["punch_basic"]
	

func handle_input() -> void:
	if player != null:
		if player_slot == null:
			player_slot = player.reserve_slot(self)
		
		if player_slot != null:
			var direction := (player_slot.global_position - global_position).normalized()
			if !is_player_within_range() and can_move():
				velocity = direction * speed
			else:
				velocity = Vector2.ZERO
				
		if is_player_within_range() and can_attack():
			if !prepearing_hit:
				prepearing_hit = true
				state = State.IDLE
				time_since_prep_hit = Time.get_ticks_msec()
				velocity = Vector2.ZERO
				face_position(player.global_position.x)
		if attack_charged():
			state = State.PUNCH
			prepearing_hit = false
			time_since_last_hit = Time.get_ticks_msec()


func face_position(x_target: float) -> void:
	if x_target > global_position.x:
		character_sprite.scale.x = 1
	else:
		character_sprite.scale.x = -1

func attack_charged() -> bool:
	return prepearing_hit and (Time.get_ticks_msec() - time_since_prep_hit) >= duration_prep_hit

func can_move() -> bool:
	if prepearing_hit:
		return false
	return super.can_move()

func can_attack() -> bool:
	if (Time.get_ticks_msec() - time_since_last_hit) < duration_between_hits:
		return false
	return super.can_attack()
	

func is_player_within_range() -> bool:
	return abs((player_slot.global_position - global_position).length()) < 5

func on_hit(damage_recived: int, direction : Vector2, hit_type : HurtBox.HitType ) -> void:
	super.on_hit(damage_recived,direction, hit_type)
	if current_health <= 0:
		player.free_slot(self)
