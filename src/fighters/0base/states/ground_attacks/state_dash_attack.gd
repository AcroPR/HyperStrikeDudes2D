extends State

@export_category("States")
@export var airState: State
@export var idleState: State

@export_category("Dash Attack Properties")
@export var initialSpeed: int = 200
@export var friction: float = 0.25

var animationName: String = "DashAttack"

func enter() -> void:
	super()
	frames = 0
	parent.animationPlayer.play(animationName)
	match parent.facingRight:
		true:
			parent.velocity.x += initialSpeed
		false:
			parent.velocity.x -= initialSpeed

func process_frame(_delta: float) -> State:
	frames += 1
	if frames < 10 and inputComponent._just_pressed("heavy"):
		return parent._return_heavy_state()
	if !parent.animationPlayer.is_playing():
		return idleState
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	var groundFriction = parent._get_velocity(friction)
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, groundFriction)
	
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return airState
	
	return null
