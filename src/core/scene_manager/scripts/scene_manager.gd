class_name SceneManager
extends Node

func _ready() -> void:
	SceneLoader._load_scene("res://src/ui/fighter_select/fighter_select.tscn")

func _load_scene(instance: Node) -> void:
	for child in get_children():
		child.queue_free()
	add_child(instance)
