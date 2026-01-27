class_name BasicEnemy
extends Character

@export var player : Player
var player_slot : EnemySlot = null

func handle_input() -> void:
	if player != null and can_move():
		if player_slot == null:
			player_slot = player.reserve_slot(self)
		
		if player_slot != null:
			var direction := (player_slot.global_position - global_position).normalized()
			if (player_slot.global_position - global_position).length() < 1:
				velocity = Vector2.ZERO
			else:
				velocity = direction * speed


#func on_hit(damage_recived: int, direction : Vector2) -> void:
	#super.on_hit(damage_recived,)
