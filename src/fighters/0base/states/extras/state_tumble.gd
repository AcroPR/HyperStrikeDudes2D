extends State

const WAIT_FRAMES: int = 180

@export_category("States")
@export var airState: State
@export var getupAttackState: State
@export var getupState: State
@export var idleState: State
@export var rollState: State

func enter() -> void:
	super()
	parent.animationPlayer.play("Tumble")
	frames = 0
	parent.velocity.x = 0
	parent.isJabReset = false

func process_frame(_delta: float) -> State:
	frames += 1
	if frames >= WAIT_FRAMES:
		return getupState
	return null


func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	var groundFriction = parent._get_velocity(parent.groundFriction)
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, groundFriction)
	
	if inputComponent._just_pressed("move_left") or inputComponent._just_pressed("move_right"):
		return rollState
	
	if inputComponent._just_pressed("move_up") or inputComponent._just_pressed("jump") or inputComponent._just_pressed("block"):
		parent.isJabReset = false
		return getupState
	
	if inputComponent._just_pressed("attack"):
		return getupAttackState
	
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return airState
	
	return null
