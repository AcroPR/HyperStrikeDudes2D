extends State

@export_category("States")
@export var airState: State
@export var idleState: State

func enter() -> void:
	super()
	parent.animationPlayer.play("Hit")

func process_frame(_delta: float) -> State:
	#if !parent.animationPlayer.is_playing():
		#return idleState
	return null

func process_physics(_delta: float) -> State:
	parent.global_position = parent.grabLocation.global_position
	
	return null
