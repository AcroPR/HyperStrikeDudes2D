extends State

@export_category("States")
@export var airState: State
@export var grabState: State
@export var idleState: State
@export var jumpSquatState: State

var moveDir

func enter() -> void:
	super()
	moveDir = [inputComponent._pressed("move_left"),inputComponent._pressed("move_right")]
	parent._set_face_with_move_dir(moveDir)
	frames = 0

func process_frame(_delta: float) -> State:
	frames += 1
	if frames <= 5:
		moveDir = [inputComponent._pressed("move_left"),inputComponent._pressed("move_right")]
		parent._set_face_with_move_dir(moveDir)
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	var groundFriction = parent._get_velocity(parent.groundFriction)
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, groundFriction*0.75)
	
	parent.move_and_slide()
	
	if inputComponent._just_pressed("jump"):
		if inputComponent._pressed("move_down"):
			parent.set_collision_mask_value(3,false)
		else:
			return jumpSquatState
	
	if parent.velocity.x == 0:
		return idleState
	
	if !parent.is_on_floor():
		return airState
	
	return null
