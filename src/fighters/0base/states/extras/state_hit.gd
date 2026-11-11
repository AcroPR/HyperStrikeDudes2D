extends State

const HORIZONTAL_DRIFT: int = 10
const DRIFT: int = 10

@export_category("States")
@export var airState: State
@export var idleState: State

# Knockback Formula
func _knockback_calc(percent, baseKnockback, knockbackScale) -> float:
	return (baseKnockback * 10) + ((percent*baseKnockback)*knockbackScale * 0.75)
	#return (baseKnockback + ((percent*baseKnockback)*knockbackScale))

# Calculates the launch vector to apply knockback
# @param launchAngle - angle (int)
# @param force - base_knockback (int)
# @returns Vector to apply knockback
func _get_launch_vector(launchAngle,force):
	#Converts angle to radians
	launchAngle = launchAngle * PI / 180
	
	#Get X and Y components of vector
	var fx = force * cos(launchAngle)
	var fy = -force * sin(launchAngle)
	
	#Returns the vector of fx and fy
	match parent.hitboxReversed:
		true:
			return Vector2(fx*-1,fy)
		false:
			return Vector2(fx,fy)
	
	return Vector2(fx,fy)

func enter() -> void:
	super()
	parent.animationPlayer.play("Hit")
	var distance = _knockback_calc(parent.percent, parent.hitboxBKB, parent.hitboxKBS)
	parent.velocity = _get_launch_vector(parent.hitboxAngle, distance)
	frames = 0

func process_frame(_delta: float) -> State:
	frames += 1
	if frames >= parent.hitStun:
		if !parent.is_on_floor():
			return airState
		return idleState
	return null

func process_physics(delta: float) -> State:
	var xDir = inputComponent._get_strength("move_right") - inputComponent._get_strength("move_left")
	parent.velocity.x += DRIFT * xDir * parent.diMulitplier
	
	match parent.ledgeLock:
		true:
			parent.velocity.y += parent._get_velocity(27.0) * delta
		false:
			parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, HORIZONTAL_DRIFT)
	
	parent.move_and_slide()
	
	return null
