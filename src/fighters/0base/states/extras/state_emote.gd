extends State

@export_category("States")
@export var idleState: State
@export var airState: State

var animationName: String

func enter() -> void:
	super()
	parent.animationPlayer.play("Emote")

func process_frame(_delta: float) -> State:
	if !parent.animationPlayer.is_playing():
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
