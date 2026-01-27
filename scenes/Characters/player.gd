class_name Player
extends Character

@onready var enemy_slots : Array = $EnemySlot.get_children()

func handle_input() -> void:
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = direction * speed
	if can_attack() and Input.is_action_just_pressed("Attack"):
		if state == State.JUMP:
			state = State.JUMP_KICK
		else:
			state = State.ATTACK
	if can_jump() and Input.is_action_just_pressed("Jump"):
		state = State.TAKEOFF

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
		vacant_slot[0].free_up()
