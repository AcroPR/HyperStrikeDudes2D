extends State

const HORIZONTAL_DRIFT: int = 10
const DRIFT: int = 10
const SPEED_LIMIT: int = 1500
const TECH_WINDOW: int = 10

@export_category("States")
@export var airState: State
@export var idleState: State
@export var rollState: State

var previousVelocity: Vector2
var attemptingToTech: bool
var techFrames: int

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
	attemptingToTech = false
	techFrames = 0
	var distance = _knockback_calc(parent.percent, parent.hitboxBKB, parent.hitboxKBS)
	parent.velocity = _get_launch_vector(parent.hitboxAngle, distance)
	frames = 0
	if parent.is_on_floor() and parent.velocity.y > SPEED_LIMIT:
		parent.velocity.y *= -0.5

func process_frame(_delta: float) -> State:
	frames += 1
	if frames >= parent.hitStun:
		if !parent.is_on_floor():
			return airState
		return idleState
	return null

func tech_check():
	match attemptingToTech:
		true:
			if techFrames < TECH_WINDOW:
				techFrames += 1
		false:
			if inputComponent._just_pressed("block"):
				attemptingToTech = true

func process_physics(delta: float) -> State:
	var xDir = inputComponent._get_strength("move_right") - inputComponent._get_strength("move_left")
	parent.velocity.x += DRIFT * xDir * parent.diMulitplier
	
	previousVelocity = parent.velocity
	
	match parent.ledgeLock:
		true:
			parent.velocity.y += parent._get_velocity(27.0) * delta
		false:
			parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, HORIZONTAL_DRIFT)
	
	parent.move_and_slide()
	
	tech_check()
	
	if parent.is_on_wall() and (previousVelocity.x > SPEED_LIMIT or previousVelocity.x < -SPEED_LIMIT):
		parent.velocity.x = previousVelocity.x * -0.5
	
	if parent.is_on_floor() and previousVelocity.y > SPEED_LIMIT:
		if techFrames < TECH_WINDOW:
			parent.velocity = Vector2.ZERO
			if inputComponent._just_pressed("move_left") or inputComponent._just_pressed("move_right"):
				return rollState
			return idleState
		else:
			parent.velocity.y = previousVelocity.y * -0.5
	
	return null
