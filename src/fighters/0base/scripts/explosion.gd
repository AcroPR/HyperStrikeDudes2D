class_name FighterExplosion
extends Node2D

@onready var circle: CPUParticles2D = $Circle
@onready var poly: CPUParticles2D = $Poly
@onready var stars: CPUParticles2D = $Stars
@onready var square: CPUParticles2D = $Square

var xVelocity = 0
var yVelocity = 0

func _set_particles(particles: CPUParticles2D):
	particles.one_shot = true
	particles.direction = Vector2(-xVelocity, -yVelocity)
	particles.emitting = true
	particles.color = Color(randf(), randf(), randf())

func _ready() -> void:
	_set_particles(circle)
	_set_particles(poly)
	_set_particles(stars)
	_set_particles(square)

func _on_finished() -> void:
	queue_free()
