class_name Player
extends Character

@onready var enemy_slots : Array = $EnemySlot.get_children()

func handle_input() -> void:
	if can_move():
		var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
		velocity = direction * speed
	
	if can_jump() and Input.is_action_just_pressed("Jump"):
		state = State.IDLE
		
	if can_attack():
		if Input.is_action_just_pressed("Punch"):
			state = State.PUNCH
			punch_combo_index = (punch_combo_index + 1) % 3
			kick_combo_index = 0
			velocity = Vector2.ZERO
		if Input.is_action_just_pressed("Kick"):
			state = State.KICK
			kick_combo_index = (kick_combo_index + 1) % 3
			punch_combo_index = 0
			velocity = Vector2.ZERO
			

func reserve_slot(enemy : BasicEnemy) -> EnemySlot:
	var available_slots = enemy_slots.filter(
		func(s : EnemySlot): return s.is_free()
	)
	if available_slots.is_empty():
		return null
	
	available_slots.sort_custom(
		func (slotA : EnemySlot, slotB : EnemySlot): 
			var distA = (slotA.global_position - enemy.global_position).length()
			var distB = (slotB.global_position - enemy.global_position).length()
			return abs(distA) < abs(distB)
	)
	
	var slot : EnemySlot = available_slots[0]
	
	slot.occupy(enemy)
	return slot
	

func free_slot(enemy: BasicEnemy) -> void:
	var vacant_slot := enemy_slots.filter(
		func (slot : EnemySlot): return slot.occupant == enemy
	)
	
	if vacant_slot.size() == 1:
		vacant_slot[0].free_slot()
