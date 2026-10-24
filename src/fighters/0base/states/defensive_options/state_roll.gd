extends State

@export_category("States")
@export var airState: State
@export var idleState: State

var moveDir

func _roll_start_up():
	match parent.facingRight:
		true:
			parent.velocity.x = -750
		false:
			parent.velocity.x = 750

func enter() -> void:
	super()
	moveDir = [!inputComponent._pressed("move_left"),!inputComponent._pressed("move_right")]
	parent._set_face(moveDir)
	_roll_start_up()

func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, 25)
	
	parent.move_and_slide()
	
	if parent.velocity.x == 0:
		return idleState
	
	if inputComponent._get_strength("move_down") >= parent.RUN_THRESHOLD:
		parent.set_collision_mask_value(3,false)
	
	if !parent.is_on_floor():
		return airState
	
	return null
