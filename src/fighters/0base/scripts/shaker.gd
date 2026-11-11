class_name Shaker
extends Node

func _shake(model: Node2D, intensity: float = 5.0, duration: float = 0.1):
	var originalPosition = model.position
	var elapsed = 0.0
	while elapsed < duration:
		model.position = originalPosition + Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		await get_tree().process_frame
		elapsed += get_process_delta_time()

	model.position = originalPosition
