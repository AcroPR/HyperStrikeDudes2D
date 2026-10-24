extends State

@export_category("States")
@export var airState: State
@export var idleState: State

func enter() -> void:
	super()
	parent.airJumpCount = 0
	parent.ledgeGrabCount = 0

func process_frame(_delta: float) -> State:
	parent.landingFrames -= 1
	if parent.landingFrames <= 0:
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
