extends Label

signal timerEnd

@onready var timer: Timer = $Timer

var runTimer: bool

func _ready() -> void:
	if MatchGlobal.timer:
		text = _set_time()
		timer.wait_time = MatchGlobal.startingMinutes * 60
		timer.start()
		runTimer = true
	else:
		text = ""
		runTimer = false

func _set_time() -> String:
	var total_seconds: int = int(timer.time_left)
	@warning_ignore("integer_division")
	var minutes: int = total_seconds / 60
	var seconds: int = total_seconds % 60
	return str(minutes) + ":" + str(seconds)

func _process(_delta: float) -> void:
	if runTimer: text = _set_time()

func _on_timer_timeout() -> void:
	emit_signal("timerEnd")
	timer.stop()
	runTimer = false
