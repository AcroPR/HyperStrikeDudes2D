extends State

@export_category("States")
@export var airState: State
@export var idleState: State

func enter() -> void:
	super()
	frames = 0
	parent.animationPlayer.play("Tech")

func process_frame(_delta: float) -> State:
	parent._set_invisibility(frames > 15)
	if !parent.animationPlayer.is_playing():
		if !parent.is_on_floor(): return airState
		return idleState
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	var groundFriction = parent._get_velocity(parent.groundFriction)
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, groundFriction)
	
	parent.move_and_slide()
	
	return null
