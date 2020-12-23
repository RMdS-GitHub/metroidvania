"""
PROJECTILE.GD

"""
extends Node2D

var velocity = Vector2.ZERO


"""
FUNC _PROCESS()

"""
func _process(delta: float) -> void:
	position += velocity * delta


"""
FUNC _ON_VISIBILITYNOTIFIER2D_VIEWPORT_EXITED()

Signal from VisibilyNotifier2D.
"""
func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport) -> void:
	queue_free()
