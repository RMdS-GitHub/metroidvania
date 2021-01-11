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
# warning-ignore:unused_argument
func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport) -> void:
	queue_free()


"""
FUNC _ON_HITBOX_BODY_ENTERED()
"""
func _on_Hitbox_body_entered(body: Node) -> void:
	queue_free()

"""
FUNC _ON_HITBOX_BODY_ENTERED()

When it hits a hurtbox it will destroy itself.
"""
func _on_Hitbox_area_entered(area: Area2D) -> void:
	queue_free()
