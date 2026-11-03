extends State

const DEPLETION: int = 24

@export_category("States")
@export var airState: State
@export var idleState: State

func enter() -> void:
	super()
	parent.animationPlayer.play("Stun")

func process_frame(_delta: float) -> State:
	if !parent.animationPlayer.is_playing():
		parent.blockHealth = parent.MAX_BLOCK_HEALTH / 2.0
		return idleState
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	var groundFriction = parent._get_velocity(parent.groundFriction)
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, groundFriction)
	
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return airState
	
	return null
