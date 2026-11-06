extends CanvasLayer

signal loading_screen_ready

@onready var progressBar = $ProgressBar

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	loading_screen_ready.emit()

func _on_progress_changed(newValue: float) -> void:
	progressBar.value = newValue

func _on_load_finished() -> void:
	#await get_tree().create_timer(2.0).timeout
	queue_free()
